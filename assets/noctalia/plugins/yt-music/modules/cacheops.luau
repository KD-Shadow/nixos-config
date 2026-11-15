local store = require("./store.luau")

local api = require("../api.luau")
local state = store.state

local const = require("../api/constants.luau")
local AUDIO_DIR = const.AUDIO_DIR
local STREAMS_CACHE_DIR = const.STREAMS_CACHE_DIR
local THUMB_DIR = const.THUMB_DIR
local PLAYLISTS_CACHE_DIR = const.PLAYLISTS_CACHE_DIR

local TARGET_DIRS = {
	streams = STREAMS_CACHE_DIR,
	thumbnails = THUMB_DIR,
	playlists = PLAYLISTS_CACHE_DIR,
}

local function human_bytes(n)
	n = tonumber(n) or 0
	if n >= 1073741824 then
		return string.format("%.1fG", n / 1073741824)
	end
	if n >= 1048576 then
		return string.format("%.1fM", n / 1048576)
	end
	if n >= 1024 then
		return string.format("%.0fK", n / 1024)
	end
	return tostring(n) .. "B"
end

-- Intentional downloads: explicit ⬇ saves + every track of fully-downloaded playlists
local function get_intentional()
	local intentional = {}
	for vid in pairs(state.offline_meta or {}) do
		intentional[vid] = true
	end
	for pid in pairs(state.downloaded_playlist_ids or {}) do
		local tracks = api.load_cached_playlist(pid)
		if tracks then
			for _, tr in ipairs(tracks) do
				if tr.id then
					intentional[tr.id] = true
				end
			end
		end
	end
	return intentional
end

local Cache = {}

-- One fileInfo per entry is cheap, but the streams/thumb dirs hold hundreds of
-- files and the sum used to run in a single 25 ms callback. Crossing the budget
-- aborted the walk mid-way, so the stats panel stayed on "refreshing" and a few
-- more overruns could auto-disable the plugin. Walk in bounded slices instead.
local STATS_CHUNK = 120

-- A slice is spawned as a `true` command; the host refuses spawns when every
-- async slot is busy (page walks, downloads). Remember only a refused step so
-- the service update tick can retry it, and clear that handle once a retry is
-- actually accepted — clearing it on every accepted spawn would lose the walk
-- when a later slice inside the same chain gets refused.
local stats_stalled = nil

local function stats_tick(fn)
	if noctalia.runAsync("true", fn) == false then
		stats_stalled = fn
	end
end

-- Called from the service update tick to resume a refused slice.
function Cache.pump_stats()
	local fn = stats_stalled
	if not fn then
		return
	end
	stats_stalled = nil
	if noctalia.runAsync("true", fn) == false and not stats_stalled then
		stats_stalled = fn
	end
end

local function queue_dir(jobs, dir_path, key, audio)
	if not noctalia.fileExists(dir_path) then
		return
	end
	local entries = noctalia.listDir(dir_path)
	if type(entries) ~= "table" then
		return
	end
	for _, name in ipairs(entries) do
		table.insert(jobs, { path = dir_path .. "/" .. name, key = key, name = name, audio = audio })
	end
end

function Cache.fetch_stats()
	if state.refreshing_cache_stats or stats_stalled then
		-- Already walking (or waiting for a free async slot): one accumulator is
		-- enough and a second pass would only double the fileInfo load.
		return
	end
	state.refreshing_cache_stats = true
	store.publish()

	local function start()
		local intentional = get_intentional()
		local totals = { audio = 0, dl = 0, streams = 0, thumbnails = 0, playlists = 0 }
		local jobs = {}
		queue_dir(jobs, AUDIO_DIR, "audio", true)
		queue_dir(jobs, STREAMS_CACHE_DIR, "streams", false)
		queue_dir(jobs, THUMB_DIR, "thumbnails", false)
		queue_dir(jobs, PLAYLISTS_CACHE_DIR, "playlists", false)

		local idx = 0

		local function step()
			local stop = math.min(idx + STATS_CHUNK, #jobs)
			while idx < stop do
				idx = idx + 1
				local job = jobs[idx]
				local info = noctalia.fileInfo(job.path)
				if info and not info.isDir then
					local sz = info.size or 0
					totals[job.key] = totals[job.key] + sz
					if job.audio then
						local vid = job.name:match("([%w%-_]+)%.opus$")
						if vid and intentional[vid] then
							totals.dl = totals.dl + sz
						end
					end
				end
			end
			if idx < #jobs then
				stats_tick(step)
				return
			end
			local cached_bytes = totals.audio - totals.dl
			if cached_bytes < 0 then
				cached_bytes = 0
			end
			state.cache_stats = {
				streams = human_bytes(totals.streams),
				thumbnails = human_bytes(totals.thumbnails),
				playlists = human_bytes(totals.playlists),
				audio = human_bytes(totals.audio),
				downloads = human_bytes(totals.dl),
				cached_audio = human_bytes(cached_bytes),
			}
			state.refreshing_cache_stats = false
			store.publish()
		end

		stats_tick(step)
	end

	if noctalia.runAsync("sleep 0.25", start) == false then
		-- The host had no free async slot; pump_stats() retries this later.
		stats_stalled = start
	end
end

-- rm target allowlist: the request channel is external input, so anything
-- outside these names is refused rather than interpolated.
local ALLOWED_TARGETS = {
	downloads = true,
	cached_audio = true,
	streams = true,
	thumbnails = true,
	playlists = true,
}

local function clear_dir(dir_path: string)
	if not noctalia.fileExists(dir_path) then
		return
	end
	local entries = noctalia.listDir(dir_path)
	if type(entries) ~= "table" then
		return
	end
	for _, name in ipairs(entries) do
		noctalia.removeFile(dir_path .. "/" .. name)
	end
end

function Cache.clear(target)
	if type(target) ~= "string" or not ALLOWED_TARGETS[target] then
		return
	end

	if target == "downloads" then
		local intentional = get_intentional()
		for vid in pairs(intentional) do
			local path = AUDIO_DIR .. "/" .. vid .. ".opus"
			if noctalia.fileExists(path) then
				noctalia.removeFile(path)
			end
		end
		state.offline_meta = {}
		require("./library.luau").save_offline_meta()
		require("./library.luau").sync_audio_cache()
	elseif target == "cached_audio" then
		local intentional = get_intentional()
		if noctalia.fileExists(AUDIO_DIR) then
			local entries = noctalia.listDir(AUDIO_DIR)
			if type(entries) == "table" then
				for _, name in ipairs(entries) do
					local vid = name:match("([%w%-_]+)%.opus$")
					if vid and not intentional[vid] then
						noctalia.removeFile(AUDIO_DIR .. "/" .. name)
					end
				end
			end
		end
		require("./library.luau").sync_audio_cache()
	elseif TARGET_DIRS[target] then
		clear_dir(TARGET_DIRS[target])
	end
	if target == "thumbnails" then
		if api and api.reset_thumb_cache then
			api.reset_thumb_cache()
		end
		local reset_items = function(items)
			if type(items) == "table" then
				for _, item in ipairs(items) do
					if type(item) == "table" then
						item.thumb_path = nil
					end
				end
			end
		end
		reset_items(state.library)
		reset_items(state.recent_playlists)
		local home_items = {}
		if type(state.home_sections) == "table" then
			for _, section in ipairs(state.home_sections) do
				if type(section) == "table" and type(section.items) == "table" then
					reset_items(section.items)
					for _, item in ipairs(section.items) do
						table.insert(home_items, item)
					end
				end
			end
		end
		if type(state.search) == "table" then
			reset_items(state.search.results)
		end
		if api and api.ensure_thumbnails then
			if type(state.library) == "table" and #state.library > 0 then
				api.ensure_thumbnails(state.library, store.publish, "library")
			end
			if type(state.recent_playlists) == "table" and #state.recent_playlists > 0 then
				api.ensure_thumbnails(state.recent_playlists, store.publish, "recent")
			end
			if #home_items > 0 then
				api.ensure_thumbnails(home_items, store.publish, "home")
			end
		end
		store.publish()
	end

	Cache.fetch_stats()
end

return Cache
