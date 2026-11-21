--!strict

-- Add a track to one of the signed-in user's playlists.
-- ytmusicapi's `add_playlist_items` uses the browse/edit_playlist endpoint
-- with an ACTION_ADD_VIDEO action; DEDUPE_OPTION_SKIP makes re-adding a track
-- a no-op instead of an error.

local logger = require("../utils/log.luau")
local log = logger.module("ytapi", "playlistedit")
local it = require("./innerTube.luau")
local const = require("./constants.luau")
local helpers = require("../utils/helpers.luau")

local EXPO = {}

local function normalize_playlist_id(id)
	if type(id) ~= "string" then
		return nil
	end
	local pid = helpers.sanitize(id)
	-- Library rows carry browse ids ("VL" + playlist id), while the edit
	-- endpoint expects the bare playlist id.
	pid = (pid:gsub("^VL", ""))
	if not pid:match("^PL[%w%-_]+$") then
		return nil
	end
	return pid
end

local function normalize_video_id(id)
	if type(id) ~= "string" then
		return ""
	end
	return (helpers.sanitize(id):gsub("[^%w%-_]", ""))
end

function EXPO.add_to_playlist(video_id, playlist_id, cb)
	local vid = normalize_video_id(video_id)
	local pid = normalize_playlist_id(playlist_id)
	if vid == "" or not pid then
		cb(false, "invalid id")
		return
	end

	log("add_to_playlist: video=" .. vid .. " playlist=" .. pid)
	it.innerTube("browse/edit_playlist", {
		context = const.CONTEXT.context,
		playlistId = pid,
		actions = {
			{
				action = "ACTION_ADD_VIDEO",
				addedVideoId = vid,
				dedupeOption = "DEDUPE_OPTION_SKIP",
			},
		},
	}, function(data, err)
		if err then
			log("add_to_playlist failed: " .. tostring(err))
			cb(false, tostring(err))
			return
		end
		if type(data) ~= "table" then
			cb(false, "no response")
			return
		end
		local status = tostring(data.status or "")
		if status:find("SUCCEEDED", 1, true) then
			cb(true, "ok")
			return
		end
		local detail = tostring(data.error or data.message or (status ~= "" and status) or "failed")
		log("add_to_playlist rejected: " .. detail)
		cb(false, detail)
	end)
end

return EXPO
