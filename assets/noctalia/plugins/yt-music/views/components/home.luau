local theme = require("../../utils/theme.luau")
local state = require("../state.luau")
local request = require("../actions.luau")
local common = require("../common.luau")

local function kind_icon(kind)
	if kind == "artist" then
		return "user"
	elseif kind == "album" then
		return "disc"
	elseif kind == "playlist" then
		return "playlist"
	end
	return "music"
end

local function kind_fallback_subtitle(kind)
	if kind == "artist" then
		return "Artist"
	elseif kind == "album" then
		return "Album"
	elseif kind == "playlist" then
		return "Playlist"
	end
	return "Song"
end

local function build_section(section, section_idx)
	local data = state.data
	local view = state.view
	local rows = {}

	table.insert(
		rows,
		ui.row({
			key = "home-section-head-" .. section_idx,
			align = "center",
			justify = "space_between",
			radius = theme.radius,
		}, {
			ui.label({
				text = tostring(section.title or "For you"):upper(),
				fontSize = theme.fontHeading,
				fontWeight = "bold",
				color = "on_surface",
			}),
		})
	)

	-- Clicking a song starts the shelf as a queue (like YouTube Music);
	-- browse cards open the playlist, album, or artist instead.
	local song_queue = {}
	local song_index = {}
	for _, item in ipairs(section.items or {}) do
		if item.kind == "song" and item.id and item.id ~= "" then
			table.insert(song_queue, item)
			song_index[item.id] = #song_queue
		end
	end

	local cards = {}
	for idx, item in ipairs(section.items or {}) do
		local key = "home-" .. section_idx .. "-" .. idx
		local kind = item.kind or "song"
		local is_hovered = (view.hover_key.card == key)
		local is_current = (data.player.id ~= "" and item.id ~= nil and data.player.id == item.id)
		local subtitle = item.subtitle or item.artist or ""
		if subtitle == "" then
			subtitle = kind_fallback_subtitle(kind)
		end

		table.insert(
			cards,
			ui.column({
				key = key,
				gap = 10,
				padding = 10,
				borderWidth = 1,
				border = is_current and "primary" or "primary/0.4",
				fill = is_current and "primary/0.15" or (is_hovered and "primary/0.12" or "primary/0.04"),
				flexGrow = 1,
				radius = theme.radius,
				onClick = function()
					view.hover_key.card = nil
					if kind == "artist" then
						state.open_artist({
							id = item.id,
							title = item.title,
							name = item.title,
							thumbnail_url = item.thumbnail_url,
							thumb_path = item.thumb_path,
						})
					elseif kind == "album" or kind == "playlist" then
						state.open_playlist(item)
					elseif song_index[item.id] then
						request(
							"replace_queue_and_play",
							{ item = item, index = song_index[item.id], queue = song_queue }
						)
					else
						state.play_item(item)
					end
				end,
				onHover = "onCardHover",
			}, {
				common.thumb_or_placeholder(
					item.thumb_path,
					200,
					kind_icon(kind),
					38,
					"primary",
					(is_current or is_hovered) and "primary/0.2" or "surface_container/0.6"
				),
				ui.column({ gap = 2, flexGrow = 1, radius = theme.radius }, {
					ui.label({
						text = item.title or "Unknown",
						fontSize = theme.fontTitle,
						fontWeight = is_current and "bold" or nil,
						maxLines = 1,
						color = is_current and "primary" or "on_surface",
					}),
					ui.row({
						key = key .. "-meta",
						gap = 2,
						align = "center",
						flexGrow = 1,
						radius = theme.radius,
					}, {
						ui.label({
							text = subtitle,
							fontSize = theme.fontTitle,
							maxLines = 1,
							flexGrow = 1,
							color = "on_surface_variant",
						}),
						(kind == "song") and ui.button({
							key = key .. "-menu",
							glyph = "dots-vertical",
							variant = "ghost",
							controlSize = "sm",
							tooltip = "Track actions",
							onClick = function() end,
							onRightClick = function()
								state.open_track_context_menu(item)
							end,
						}) or ui.row({ key = key .. "-meta-pad", borderWidth = 0, radius = theme.radius }),
					}),
				}),
			})
		)
	end

	for _, row in ipairs(common.chunk_rows(cards, 6, "home-" .. section_idx, 14)) do
		table.insert(rows, row)
	end

	return rows
end

local function build_home()
	local data = state.data
	local feed = {}
	local is_refreshing = (data.refreshing_home == true)

	table.insert(
		feed,
		ui.row({ key = "home-header", align = "center", justify = "space_between", radius = theme.radius }, {
			ui.row({ align = "center", gap = 8, radius = theme.radius }, {
				ui.glyph({ name = "sparkles", size = 18, color = "primary" }),
				ui.column({ gap = 1, radius = theme.radius }, {
					ui.label({
						text = "FOR YOU",
						fontSize = theme.fontHeading,
						fontWeight = "bold",
						color = "primary",
					}),
					ui.label({
						text = "Fresh shelves built from your listening history",
						fontSize = theme.fontTitle,
						color = "on_surface_variant",
					}),
				}),
			}),
			ui.button({
				key = "btn-refresh-home",
				glyph = is_refreshing and "loader" or "refresh",
				variant = "ghost",
				controlSize = "sm",
				tooltip = is_refreshing and "Refreshing For You..." or "Refresh For You",
				onClick = if is_refreshing
					then nil
					else function()
						request("refresh_home", { force = true })
					end,
			}),
		})
	)
	table.insert(feed, ui.row({ key = "spacer-home-top", height = 4, borderWidth = 0, radius = theme.radius }))

	if type(data.home_sections) == "table" and #data.home_sections > 0 then
		for section_idx, section in ipairs(data.home_sections) do
			if type(section) == "table" and type(section.items) == "table" and #section.items > 0 then
				if section_idx > 1 then
					table.insert(
						feed,
						ui.row({
							key = "home-gap-" .. section_idx,
							height = 6,
							borderWidth = 0,
							radius = theme.radius,
						})
					)
					table.insert(
						feed,
						ui.separator({ key = "home-sep-" .. section_idx, color = "outline_variant/0.3" })
					)
					table.insert(
						feed,
						ui.row({
							key = "home-sep-gap-" .. section_idx,
							height = 6,
							borderWidth = 0,
							radius = theme.radius,
						})
					)
				end
				for _, item in ipairs(build_section(section, section_idx)) do
					table.insert(feed, item)
				end
			end
		end
	else
		local text
		if not state.logged_in() then
			text = "Sign in to load your personalized home feed."
		elseif is_refreshing then
			text = "Loading your For You feed..."
		else
			text = "No home feed yet. Refresh to try again."
		end
		table.insert(
			feed,
			ui.label({
				text = text,
				fontSize = theme.fontTitle,
				color = "on_surface_variant",
			})
		)
	end

	return feed
end

return { build = build_home }
