--!strict

-- thumbnail path/ensure/attach helpers.

local const = require("./constants.luau")
local THUMB_DIR = const.THUMB_DIR

local scratch = require("../utils/scratch.luau")
local network = require("../utils/network.luau")

local EXPO = {}

-- Thumbnail filename = stable resource id extracted from the URL itself:
--   yt3.googleusercontent.com/<seg>=w120…          → <seg>
--   lh3.googleusercontent.com/<prefix>/<seg>=s576  → <seg>, when short enough
--   i.ytimg.com/vi/<videoId>/hqdefault.jpg         → <videoId>
-- Identical covers therefore collapse to one file/download with zero hashing
-- or extra machinery. Unrecognised shapes fall back to the legacy per-id name
-- (dedup skipped for those, none observed in practice).
local function thumb_key(url): string?
	if type(url) ~= "string" or url == "" then
		return nil
	end
	local seg1 = url:match("yt3%.googleusercontent%.com/([^/=]+)")
	if seg1 and seg1 ~= "" then
		return seg1
	end
	-- Podcast artwork is the two-segment shape, where the FIRST segment is a
	-- constant ("youtube-podcasts-ingestion-proxy") and the id is the second.
	-- Keying these on the first segment put every show in the library on one
	-- cached file — the first show's cover, drawn for all of them.
	local seg2b = url:match("lh3%.googleusercontent%.com/[^/]+/([^/=]+)")
	if seg2b and seg2b ~= "" then
		-- …but that second segment is an opaque signed reference, 250–300
		-- characters in practice: past the 255-byte filename cap, and it changes
		-- whenever the signature rotates. Neither fits a cache filename, so give
		-- up on it (returning nil, never falling through to the constant first
		-- segment below) and let the caller name the file after the item — one
		-- file per show, stable across rotations.
		if #seg2b > 128 then
			return nil
		end
		return seg2b
	end
	local seg2 = url:match("lh3%.googleusercontent%.com/([^/=]+)")
	if seg2 and seg2 ~= "" then
		return seg2
	end
	local vid = url:match("i%.ytimg%.com/vi/([%w%-_]+)")
	if vid and vid ~= "" then
		return vid
	end
	return nil
end

-- Content-addressed thumbnail path: one file per unique source resource, so
-- album playlists sharing a cover download (and store) it exactly once.
-- Falls back to the legacy per-id name when no key is extractable.
function EXPO.path_for(id: string, url: string?): string
	local key = thumb_key(url)
	if key then
		return THUMB_DIR .. "/" .. key .. ".jpg"
	end
	return THUMB_DIR .. "/" .. id .. ".jpg"
end

local path_for = EXPO.path_for

function EXPO.get_thumbnail_path(id: string, url: string?, callback: ((string) -> ())?): string?
	if type(id) ~= "string" or id == "" then
		return nil
	end
	local path = path_for(id, url)

	if noctalia.fileExists(path) then
		return path
	end

	if type(url) == "string" and url ~= "" then
		noctalia.mkdirAll(THUMB_DIR)
		network.runAsync({ "curl", "-s", "-L", "-o", path, url }, function()
			if noctalia.fileExists(path) and callback then
				callback(path)
			end
		end, 10000)
	end

	return nil
end

local known_thumb_files = {}

local function preload_thumb_cache()
	noctalia.mkdirAll(THUMB_DIR)
	do
		local _e = noctalia.listDir(THUMB_DIR)
		if type(_e) == "table" then
			for _, _n in ipairs(_e) do
				known_thumb_files[THUMB_DIR .. "/" .. tostring(_n)] = true
			end
		end
	end
end
preload_thumb_cache()

-- Thumbnail work is chunked across async ticks. A playlist can hold hundreds
-- or thousands of rows, and both the scan and the post-download attach loop
-- used to run inside a single 25 ms callback. On large lists that overran the
-- budget; five overruns in a minute make Noctalia auto-disable the plugin.
-- Each tick now touches a bounded slice and yields, so cost scales with rows
-- while per-callback CPU stays flat.
local SCAN_CHUNK = 64
local BUILD_CHUNK = 64
local ATTACH_CHUNK = 64

-- One job per tag ("playlist", "queue", "home"…). A second request for the
-- same tag while its job is in flight only refreshes the inputs: identical
-- passes coalesce instead of queueing duplicate scans/downloads.
local ensure_jobs = {}
local ensure_active = nil
local process_job

-- A chunk tick is a spawned `true` command, and the host refuses to spawn one
-- when too many async commands are already in flight (rapid skipping and page
-- walks can fill the slots). Dropping the tick would leave `ensure_active` set
-- forever and silently stop all thumbnail work, so remember the pending step
-- and let the service update tick retry it.
local stalled_tick = nil

local function next_tick(fn)
	if noctalia.runAsync("true", fn) == false then
		stalled_tick = fn
	end
end

-- Called from the service update tick. Re-spawn rather than running the chunk
-- inline, so recovery stays inside its own async callback budget.
function EXPO.pump_thumbnails()
	local fn = stalled_tick
	if fn and noctalia.runAsync("true", fn) ~= false then
		stalled_tick = nil
	end
end

local function finish_job(job)
	if ensure_jobs[job.key] == job then
		if job.dirty then
			job.dirty = false
			job.phase = nil
			process_job(job)
			return
		end
		ensure_jobs[job.key] = nil
	end
	ensure_active = nil
	for _, other in pairs(ensure_jobs) do
		ensure_active = other
		process_job(other)
		return
	end
end

process_job = function(job)
	if ensure_active ~= job then
		return
	end

	if job.phase == nil then
		job.phase = "scan"
		job.i = 1
		job.missing = {}
		job.updated_cached = false
	end

	if job.phase == "scan" then
		local items = job.items
		local total = #items
		local stop = math.min(total, job.i + SCAN_CHUNK - 1)
		while job.i <= stop do
			local item = items[job.i]
			if type(item) == "table" and type(item.id) == "string" and item.id ~= "" and not item.thumb_path then
				local url = (type(item.thumbnail_url) == "string" and item.thumbnail_url ~= "") and item.thumbnail_url
					or ("https://i.ytimg.com/vi/" .. item.id .. "/hqdefault.jpg")
				local path = path_for(item.id, url)
				if known_thumb_files[path] then
					item.thumb_path = path
					job.updated_cached = true
				else
					table.insert(job.missing, { item = item, path = path, url = url })
				end
			end
			job.i = job.i + 1
		end
		if job.i <= total then
			next_tick(function()
				process_job(job)
			end)
			return
		end
		if #job.missing == 0 then
			if job.updated_cached and type(job.on_updated) == "function" then
				job.on_updated()
			end
			finish_job(job)
			return
		end
		job.phase = "config"
		job.lines = {}
		job.seen_paths = {}
		job.mi = 1
		job.config_file = scratch.path("thumbcfg")
		next_tick(function()
			process_job(job)
		end)
		return
	end

	if job.phase == "config" then
		-- One config entry per unique output path: same-resource covers collapse
		-- to a single download instead of one per track.
		local missing = job.missing
		local stop = math.min(#missing, job.mi + BUILD_CHUNK - 1)
		while job.mi <= stop do
			local m = missing[job.mi]
			if not job.seen_paths[m.path] then
				job.seen_paths[m.path] = true
				-- curl -K config values: strip quotes/control chars so a hostile URL
				-- cannot inject additional curl options via the config file
				local safe_url = tostring(m.url):gsub('[%c"]', "")
				table.insert(job.lines, string.format('output = "%s"\nurl = "%s"', m.path, safe_url))
			end
			job.mi = job.mi + 1
		end
		if job.mi <= #missing then
			next_tick(function()
				process_job(job)
			end)
			return
		end
		noctalia.writeFile(job.config_file, table.concat(job.lines, "\n"))
		job.lines = nil
		job.seen_paths = nil
		noctalia.mkdirAll(THUMB_DIR)
		if not noctalia.commandExists("curl") then
			finish_job(job)
			return
		end
		job.phase = "attach"
		job.ai = 1
		job.attached = false
		network.runAsync(
			{ "curl", "-s", "--parallel", "--parallel-max", "16", "--parallel-immediate", "-K", job.config_file },
			function(_res)
				-- curl reports a single failed transfer as a non-zero exit, but every
				-- transfer that did complete is already on disk. Attach whatever
				-- landed instead of discarding the batch: one unreachable cover used
				-- to leave every newly fetched item without artwork.
				process_job(job)
			end,
			15000
		)
		return
	end

	if job.phase == "attach" then
		local missing = job.missing
		local stop = math.min(#missing, job.ai + ATTACH_CHUNK - 1)
		while job.ai <= stop do
			local m = missing[job.ai]
			if noctalia.fileExists(m.path) then
				known_thumb_files[m.path] = true
				m.item.thumb_path = m.path
				job.attached = true
			end
			job.ai = job.ai + 1
		end
		if job.ai <= #missing then
			next_tick(function()
				process_job(job)
			end)
			return
		end
		if job.attached and type(job.on_updated) == "function" then
			job.on_updated()
		end
		finish_job(job)
	end
end

function EXPO.ensure_thumbnails(items, on_updated, tag)
	if type(items) ~= "table" or #items == 0 then
		return
	end

	local key = tag or "default"
	local job = ensure_jobs[key]
	if not job then
		job = { key = key, items = items, on_updated = on_updated }
		ensure_jobs[key] = job
		if ensure_active == nil then
			ensure_active = job
			process_job(job)
		end
		return
	end

	-- Same tag again: adopt the newest list/callback. If it is the running job,
	-- flag it so the pass restarts once the current one yields.
	job.items = items
	job.on_updated = on_updated
	if ensure_active == job then
		job.dirty = true
	else
		job.phase = nil
	end
end

function EXPO.attach_cached_thumbs(items: { { [string]: any } })
	if type(items) ~= "table" then
		return
	end
	local count = #items
	if count > 50 then
		count = 50
	end
	for i = 1, count do
		local item = items[i]
		if type(item) == "table" and type(item.id) == "string" and item.id ~= "" then
			local path = path_for(item.id, item.thumbnail_url)
			if known_thumb_files[path] == nil then
				known_thumb_files[path] = noctalia.fileExists(path)
			end
			if known_thumb_files[path] then
				item.thumb_path = path
			end
		end
	end
end

function EXPO.reset_thumb_cache()
	known_thumb_files = {}
end

return EXPO
