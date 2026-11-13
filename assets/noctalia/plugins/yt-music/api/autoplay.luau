--!strict

-- Endless play ("Up next") support.
--
-- YouTube Music seeds its autoplay queue from the track radio
-- `RDAMVM<videoId>`. Requesting the /next endpoint with that playlist id
-- returns roughly 50 recommended tracks, which is enough to keep playback
-- running; the player re-seeds from the newest track whenever the batch runs
-- low.

local logger = require("../utils/log.luau")
local log = logger.module("ytapi", "autoplay")

local const = require("./constants.luau")
local CONTEXT = const.CONTEXT

local filters = require("../utils/filters.luau")
local helpers = require("../utils/helpers.luau")
local scratch = require("../utils/scratch.luau")
local network = require("../utils/network.luau")

local it = require("./innerTube.luau")

local types = require("../utils/types.luau")

local EXPO = {}

function EXPO.autoplay_tracks(seed_id: string?, cb: ({ types.Track }?, string?) -> ())
	local id = tostring(seed_id or "")
	if id == "" then
		cb(nil, "missing seed")
		return
	end
	if not network.isOnline() then
		cb(nil, "offline")
		return
	end

	local req = {
		context = CONTEXT.context,
		videoId = id,
		playlistId = "RDAMVM" .. id,
		params = "wAEB",
		isAudioOnly = true,
		enablePersistentPlaylistPanel = true,
	}

	it.innerTube("next", req, function(raw_body, err)
		if not raw_body or raw_body == "" then
			log("autoplay: empty response for seed " .. id .. " (" .. tostring(err) .. ")")
			cb(nil, err or "empty response")
			return
		end

		local raw_file = scratch.path("autoplay-raw")
		noctalia.writeFile(raw_file, raw_body)
		noctalia.runAsync({ "jq", "-a", filters.AUTOPLAY, raw_file }, function(res)
			local out_json = (type(res) == "table" and res.stdout) or ""
			local data = noctalia.json.decode(out_json)
			local rows = (type(data) == "table" and type(data.tracks) == "table") and data.tracks or {}
			local tracks: { types.Track } = {}
			for _, tr in ipairs(rows) do
				table.insert(tracks, {
					id = tr.id,
					title = helpers.clean_utf8(tr.title or ""),
					artist = helpers.clean_artist(tr.artist),
					duration = helpers.fmt_seconds(tr.duration_text),
					duration_text = tr.duration_text,
					thumbnail_url = tr.thumbnail_url,
				})
			end
			log(string.format("autoplay: seed=%s tracks=%d", id, #tracks))
			cb(tracks)
		end)
	end, true)
end

return EXPO
