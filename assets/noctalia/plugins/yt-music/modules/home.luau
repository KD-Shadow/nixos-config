local store = require("./store.luau")
local api = require("../api.luau")

local state = store.state

local Home = {}

-- Navigating back to For You after listening should eventually show fresh
-- shelves, but a click is not worth a network round-trip every time.
local MIN_REFRESH_INTERVAL = 5 * 60
local last_fetch_at = 0

-- Paint the last successful home feed immediately at boot; refresh_home()
-- replaces it once the signed-in FEmusic_home response arrives.
function Home.load_cached()
	if not (api and api.load_cached_home_sections) then
		return
	end
	local cached = api.load_cached_home_sections()
	if type(cached) == "table" and #cached > 0 then
		state.home_sections = cached
		store.publish()
	end
end

function Home.refresh_home(force)
	if not (api and api.fetch_home_sections) then
		return
	end
	if state.refreshing_home then
		return
	end
	if not force and (os.time() - last_fetch_at) < MIN_REFRESH_INTERVAL then
		return
	end
	last_fetch_at = os.time()
	state.refreshing_home = true
	store.publish()
	api.fetch_home_sections(function(sections)
		state.refreshing_home = false
		if type(sections) == "table" and #sections > 0 then
			state.home_sections = sections
		else
			-- Do not lock a failed/empty pull behind the throttle window.
			last_fetch_at = 0
		end
		store.publish()
		Home.fetch_home_thumbs()
	end)
end

function Home.fetch_home_thumbs()
	if not (api and api.ensure_thumbnails) then
		return
	end
	local combined = {}
	if type(state.home_sections) == "table" then
		for _, section in ipairs(state.home_sections) do
			if type(section) == "table" and type(section.items) == "table" then
				for _, item in ipairs(section.items) do
					table.insert(combined, item)
				end
			end
		end
	end
	if #combined > 0 then
		noctalia.runAsync("true", function()
			api.ensure_thumbnails(combined, store.publish, "home")
		end)
	end
end

return Home
