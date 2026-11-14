local Mpv = {}
local Bash = require("../utils/bash.luau")
local scratch = require("../utils/scratch.luau")
local logger = require("../utils/log.luau")
local log = logger.module("ytm", "mpv")

-- The host allows only a handful of concurrent async commands and streams per
-- plugin. A burst (rapid skipping, resolve + play + stats + prefetch at once)
-- can make runAsync/runStream return false, and a dropped mpv_play leaves the
-- UI stuck on "loading" with no process to play anything. Queue those two
-- intents instead and retry them from the service update tick.
local pending_play = nil
local pending_stream = nil

local function start_play(p)
	local url_file = scratch.path("mpv-url")
	local title_file = scratch.path("mpv-title")
	noctalia.writeFile(url_file, p.url)
	noctalia.writeFile(title_file, p.title or "")
	return Bash.run_script("mpv.sh", "mpv_play", function(res)
		local out = (type(res) == "table" and res.stdout) or ""
		local ready = out:find("READY=1", 1, true) ~= nil
		local ms = out:match("MS=(%d+)")
		log("mpv_play ready=" .. tostring(ready) .. (ms and (" in " .. ms .. "ms") or ""))
		if type(p.on_ready) == "function" then
			p.on_ready(ready)
		end
	end, 10000, tostring(p.volume or 100), url_file, title_file, p.cover_path or "")
end

-- url/title go through per-call scratch slots (rotating pool, overwritten on
-- reuse) so a fast track switch can never clobber the previous launch inputs.
function Mpv.play(url, title, volume, on_ready, cover_path)
	-- Last intent wins: a queued launch superseded before a slot frees up is
	-- dead weight, exactly like an in-flight mpv_play.
	pending_play = {
		url = url,
		title = title,
		volume = volume,
		on_ready = on_ready,
		cover_path = cover_path,
	}
	if start_play(pending_play) then
		pending_play = nil
	else
		log("mpv_play queued: no async command slot free")
	end
end

function Mpv.send(payload_json)
	local ok = Bash.run_script("mpv.sh", "mpv_send", function() end, 5000, payload_json)
	if not ok then
		-- Deliberately not retried: replaying a stale pause/seek after a newer
		-- play has started is worse than dropping it.
		log("mpv_send dropped: no async command slot free")
	end
end

function Mpv.kill()
	-- A refused launch that has not started yet is dead weight once playback is
	-- being torn down; keeping it queued would let the next flush resurrect a
	-- track the user already stopped.
	pending_play = nil
	pending_stream = nil
	local ok = Bash.run_script("mpv.sh", "mpv_kill", function() end, 2000)
	if not ok then
		log("mpv_kill dropped: no async command slot free")
	end
end

-- Persistent push stream. One handle per mpv instance; the stream ends on its
-- own when mpv dies (socket closes). Each emitted JSON line goes to on_line.
function Mpv.stream(on_line)
	pending_stream = on_line
	if Bash.run_stream("mpv.sh", "mpv_stream", on_line) then
		pending_stream = nil
	else
		log("mpv_stream queued: no stream slot free")
	end
	return true
end

-- Called from the service update tick. Starts whichever queued intents the
-- host now has room for; leaving one queued costs at most one tick.
function Mpv.flush()
	if pending_play then
		local p = pending_play
		if start_play(p) then
			pending_play = nil
		end
	end
	if pending_stream then
		local on_line = pending_stream
		if Bash.run_stream("mpv.sh", "mpv_stream", on_line) then
			pending_stream = nil
		end
	end
end

return Mpv
