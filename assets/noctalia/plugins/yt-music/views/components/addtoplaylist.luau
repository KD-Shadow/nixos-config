local theme = require("../../utils/theme.luau")
local state = require("../state.luau")
local request = require("../actions.luau")
local rerender = require("../rerender.luau")
local common = require("../common.luau")

local M = {}

-- Library rows carry browse ids ("VL" + id). Only real playlists can be
-- edited; liked songs, albums, artists and radios are not valid targets.
local function editable_playlist_id(id)
	if type(id) ~= "string" then
		return nil
	end
	local pid = (id:gsub("^VL", ""))
	pid = (pid:gsub("[^%w%-_]", ""))
	if pid:match("^PL") and #pid > 2 then
		return pid
	end
	return nil
end

function M.build()
	local data = state.data
	local view = state.view
	local track = view.add_to_playlist_track or {}
	local query = tostring(view.add_to_playlist_filter or "")
	local rows = {}

	table.insert(
		rows,
		ui.row({
			key = "atpl-head",
			align = "center",
			justify = "space_between",
			radius = theme.radius,
		}, {
			ui.column({ gap = 4, flexGrow = 1, radius = theme.radius }, {
				ui.label({ text = "ADD TO PLAYLIST", fontSize = theme.fontHero, fontWeight = "bold", color = "on_surface" }),
				ui.label({
					text = "Choose a playlist for “" .. tostring(track.title or "Track") .. "”",
					fontSize = theme.fontTitle,
					color = "on_surface_variant",
					maxLines = 1,
				}),
			}),
			ui.button({
				key = "atpl-back",
				glyph = "arrow-left",
				variant = "secondary",
				controlSize = "md",
				tooltip = "Back",
				onClick = function()
					state.close_add_to_playlist()
				end,
			}),
		})
	)

	-- Only show the result for the track this picker is currently adding.
	local status = (data.playlist_add_video_id == track.id) and tostring(data.playlist_add_status or "") or ""
	if status ~= "" then
		table.insert(
			rows,
			ui.row({
				key = "atpl-status",
				gap = 8,
				align = "center",
				padding = 8,
				radius = theme.radius,
			}, {
				ui.glyph({
					name = data.playlist_add_ok and "circle-check" or "alert-circle",
					size = 16,
					color = data.playlist_add_ok and "primary" or "error",
				}),
				ui.label({
					text = status,
					fontSize = theme.fontBody,
					color = "on_surface_variant",
					maxLines = 1,
				}),
			})
		)
	end

	local playlists = {}
	local seen = {}
	local function collect(list)
		for _, pl in ipairs(list or {}) do
			local pid = editable_playlist_id(pl.id)
			if pid and not seen[pid] then
				seen[pid] = true
				table.insert(playlists, {
					id = pid,
					title = tostring(pl.title or "Playlist"),
					subtitle = tostring(pl.subtitle or ""),
					count = tonumber(pl.count) or 0,
					thumb_path = pl.thumb_path,
				})
			end
		end
	end
	collect(data.library)
	collect(data.recent_playlists)

	if #playlists > 0 then
		table.insert(
			rows,
			ui.input({
				key = "atpl-filter",
				placeholder = "Filter playlists...",
				value = query,
				width = 300,
				onChange = function(val)
					view.add_to_playlist_filter = val or ""
					rerender.call()
				end,
			})
		)
	end

	if query ~= "" then
		local filtered = {}
		for _, pl in ipairs(playlists) do
			if common.fuzzy_match(query, pl.title) or common.fuzzy_match(query, pl.subtitle) then
				table.insert(filtered, pl)
			end
		end
		playlists = filtered
	end

	if #playlists == 0 then
		local refresh_click = nil
		if not data.refreshing_library then
			refresh_click = function()
				request("refresh_library")
			end
		end
		local message
		if #data.library == 0 then
			message = data.refreshing_library and "Loading your playlists..."
				or "No playlists loaded yet. Refresh to fetch them from YouTube Music."
		elseif query ~= "" then
			message = "No playlists match your filter."
		else
			message = "No editable playlists found. Create one in YouTube Music, then refresh."
		end
		table.insert(
			rows,
			ui.column({
				key = "atpl-empty",
				gap = 12,
				align = "center",
				justify = "center",
				padding = 32,
				radius = theme.radius,
			}, {
				ui.glyph({ name = "library", size = 44, color = "on_surface_variant/0.5" }),
				ui.label({
					text = message,
					fontSize = theme.fontBody,
					color = "on_surface_variant",
					textAlign = "center",
				}),
				ui.button({
					key = "atpl-empty-refresh",
					glyph = data.refreshing_library and "loader" or "refresh",
					tooltip = "Refresh playlists",
					variant = "outline",
					controlSize = "sm",
					onClick = refresh_click,
				}),
			})
		)
	end

	table.sort(playlists, function(a, b)
		return a.title:lower() < b.title:lower()
	end)

	local busy = (data.playlist_add_pending == true)
	for i, pl in ipairs(playlists) do
		local row_key = "atpl-pl-" .. i .. "-" .. pl.id
		local subtitle = pl.subtitle
		if subtitle == "" then
			subtitle = pl.count > 0 and (pl.count .. " tracks") or "Playlist"
		end
		local add_click = nil
		if not busy then
			add_click = function()
				request("add_to_playlist", {
					video_id = track.id,
					playlist_id = pl.id,
					title = track.title,
					playlist_title = pl.title,
				})
			end
		end
		table.insert(
			rows,
			ui.row({
				key = row_key,
				gap = 12,
				align = "center",
				padding = 8,
				borderWidth = 0,
				radius = theme.radius,
			}, {
				common.thumb_or_placeholder(pl.thumb_path, 48, "music", 22, "on_surface_variant"),
				ui.column({ gap = 2, flexGrow = 1, radius = theme.radius }, {
					ui.label({ text = pl.title, fontSize = theme.fontTitle, color = "on_surface", maxLines = 1 }),
					ui.label({
						text = subtitle,
						fontSize = theme.fontCaption,
						color = "on_surface_variant",
						maxLines = 1,
					}),
				}),
				ui.button({
					key = row_key .. "-add",
					text = busy and "Adding..." or "Add",
					variant = "secondary",
					controlSize = "sm",
					tooltip = "Add “" .. tostring(track.title or "Track") .. "” to " .. pl.title,
					onClick = add_click,
				}),
			})
		)
	end

	return { ui.column({ key = "atpl-root", gap = 10, flexGrow = 1, radius = theme.radius }, rows) }
end

return M
