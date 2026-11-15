local store = require("./store.luau")
local api = require("../api.luau")
local logger = require("../utils/log.luau")
local network = require("../utils/network.luau")
local Bash = require("../utils/bash.luau")
local BROWSERS = require("../utils/browsers.luau")
local library = require("./library.luau")
local home = require("./home.luau")

local state = store.state
local log = logger.module("ytm", "auth")

local extraction_active = false

local Auth = {}

function Auth.browser_label(id)
	for _, b in ipairs(BROWSERS) do
		if b.id == id then
			return b.label
		end
	end
	return id or "Browser"
end

function Auth.open_login(browser)
	local target = (type(browser) == "string" and browser ~= "") and browser or "default"
	local label = Auth.browser_label(target)
	state.browser = target
	state.browser_label = label
	state.login_pending = true
	state.status_text = "Opened " .. label .. ". Sign in, then click " .. label .. " again to extract."
	log("open_login: browser=" .. target)
	store.publish()
	Bash.run_script("cookies.sh", "open_browser", function() end, 5000, target)
	if noctalia.notify then
		noctalia.notify(
			"YouTube Music",
			"Opened " .. label .. ". Sign into YouTube Music, then click " .. label .. " again."
		)
	end
end

function Auth.extract_cookies(browser)
	if extraction_active then
		return
	end
	if type(browser) ~= "string" or browser == "" then
		return
	end
	if not network.isOnline() then
		state.status = "error"
		state.last_error = "You're offline — sign-in needs an internet connection"
		store.publish()
		return
	end
	local label = Auth.browser_label(browser)
	extraction_active = true
	state.extracting = true
	state.browser = browser
	state.browser_label = label
	state.status = "extracting"
	state.status_text = "Extracting cookies from " .. label .. "..."
	state.last_error = ""
	store.publish()

	Bash.run_script("cookies.sh", "extract_cookies", function(res)
		local out = (type(res) == "table" and res.stdout) or ""
		log("extract: browser=" .. tostring(browser) .. " out=" .. tostring(out:sub(1, 200)))
		local dir = out:match("DIR=([^\n]+)") or ""
		local cookies = out:match("OUT=([^\n]+)") or ""
		local total = tonumber(out:match("TOTAL=([^\n]+)") or "0") or 0
		local kept = tonumber(out:match("KEPT=([^\n]+)") or "0") or 0
		local login = out:match("LOGIN=(%d)")
		local err_log = out:match("LOG=([^\n]*)") or ""

		extraction_active = false
		state.extracting = false

		if login == "0" and kept > 0 then
			-- The capture has cookies, but none of the rows that only a signed-in
			-- Google session carries. Keep any previously saved file untouched and
			-- leave the browser open so the user can finish signing in.
			-- login_pending is cleared so the next click re-focuses the browser
			-- instead of extracting an unchanged profile again.
			state.login_pending = false
			state.status = "error"
			state.status_text = "No signed-in YouTube session found in " .. label
			state.last_error = "Sign in to YouTube Music in the browser window that opened, then pick "
				.. label
				.. " again."
			if noctalia.notify then
				noctalia.notify(
					"YouTube Music",
					"No signed-in session found in " .. label .. ". Finish signing in, then pick it again."
				)
			end
		elseif kept > 0 then
			state.status = "ready"
			state.temp_dir = dir
			state.cookies_path = cookies
			state.cookie_count = kept
			state.last_error = ""
			state.status_text = string.format(
				"Saved %d YouTube cookies from %s (filtered %d others)",
				kept,
				label,
				math.max(0, total - kept)
			)
			if noctalia.notify then
				noctalia.notify("YouTube Music", state.status_text)
			end
			if api and api.invalidate_auth then
				api.invalidate_auth()
			end
			-- Do not load library/home until the API confirms the captured
			-- cookies carry a real account session. A signed-out capture still
			-- has cookie rows, and calling these against it would leave the user
			-- with an empty library while the UI said "ready".
			Auth.verify_login(function()
				if api and api.library then
					api.library()
				end
				home.refresh_home(true)
			end)
		else
			state.status = "error"
			state.login_pending = false
			state.status_text = "No YouTube session found in " .. label
			state.last_error = err_log
			if (state.cookie_count or 0) <= 0 then
				state.cookies_path = ""
				state.temp_dir = dir
				state.cookie_count = 0
			end
			if noctalia.notify then
				noctalia.notify(
					"YouTube Music",
					"No YouTube login found in "
						.. label
						.. ". Make sure you are signed in on YouTube Music, then click again."
				)
			end
		end
		store.publish()
	end, 60000, browser)
end

-- Counting cookie rows does not prove a session: YouTube hands signed-out
-- visitors the same __Secure-3PSID/__Secure-3PAPISID pair it gives accounts.
-- Ask InnerTube, and mark the status signed-out when the probe says logged
-- out — otherwise private playlists silently render empty while the UI claims
-- the plugin is ready.
function Auth.verify_login(on_ok)
	if not (api and api.check_login) then
		if on_ok then
			on_ok()
		end
		return
	end
	api.check_login(function(ok, probe_err)
		if ok then
			state.status = "ready"
			state.login_pending = false
			state.last_error = ""
			local text = state.status_text or ""
			if text:find("signed out", 1, true) or text:find("No signed-in", 1, true) then
				state.status_text = "Signed in"
			end
			store.publish()
			if on_ok then
				on_ok()
			end
		elseif probe_err then
			-- The probe itself failed (offline, timeout). That says nothing about
			-- the session, so keep whatever status we had and continue.
			log("check_login: probe failed (" .. tostring(probe_err) .. ")")
			if on_ok then
				on_ok()
			end
		else
			state.status = "error"
			-- Leave login_pending false: the next tile click should reopen the
			-- browser (its saved profile may still hold a session) rather than
			-- jumping straight to extraction with no window on screen.
			state.login_pending = false
			state.status_text = "Saved cookies are signed out"
			state.last_error = "The stored YouTube session is signed out or expired. Open a browser, sign in to YouTube Music, then pick that browser again to extract fresh cookies."
			store.publish()
		end
	end)
end

function Auth.load_cached_cookies()
	Bash.run_script("cookies.sh", "load_cached_cookies", function(res)
		local out = (type(res) == "table" and res.stdout) or ""
		if out:find("FOUND=1") then
			local kept = tonumber(out:match("KEPT=([^\n]+)") or "0") or 0
			local cookies = out:match("OUT=([^\n]+)") or ""
			if kept > 0 then
				log("cookies: ready (" .. kept .. ")")
				state.status = "ready"
				state.cookies_path = cookies
				state.cookie_count = kept
				state.last_error = ""
				if state.status_text == "Not logged in" then
					state.status_text = string.format("Loaded %d saved YouTube cookies", kept)
				end
				if api and api.invalidate_auth then
					api.invalidate_auth()
				end
				if api and api.load_cached_playlist then
					local vllm = api.load_cached_playlist("VLLM")
					if vllm then
						library.sync_liked_tracks(vllm)
					end
				end
				home.load_cached()
				library.sync_audio_cache()
				store.publish()
				Auth.verify_login(function()
					home.refresh_home()
				end)
			end
		else
			log("cookies: none — signed out")
			state.status = "idle"
			state.status_text = "Not logged in"
			state.cookies_path = ""
			state.cookie_count = 0
			state.last_error = ""
			store.publish()
		end
	end, 8000)
end

-- Dependency health check, run at boot before the browser list is shown.
-- Result lands in state.health as name -> {status, detail}; the auth views
-- render a warning card for anything not ok. Additive only: never blocks.
function Auth.check_health()
	state.checking_health = true
	store.publish()
	Bash.run_script("health.sh", "health_check", function(res)
		local out = (type(res) == "table" and res.stdout) or ""
		local health = {}
		local parts = {}
		for name, status, detail in out:gmatch("HEALTH=([^:]+):([^:]+):([^\n]*)") do
			health[name] = { status = status, detail = detail }
			table.insert(parts, name .. "=" .. status .. ":" .. detail)
		end
		-- Full check-by-check record (versions, netcat variant, stale
		-- verdicts) lands in debug.log for remote diagnosis.
		log("health check:")
		for _, line in ipairs(parts) do
			log("  " .. line)
		end
		state.health = health
		state.checking_health = false
		store.publish()
	end, 15000)
end

function Auth.detect_browsers()
	Bash.run_script("cookies.sh", "detect_browsers", function(res)
		local out = (type(res) == "table" and res.stdout) or ""
		local available = {}
		local found = {}
		for id in out:gmatch("FOUND=([^\n]+)") do
			available[id] = true
			table.insert(found, id)
		end
		state.available = available
		log("browsers: " .. (#found > 0 and table.concat(found, ",") or "none detected"))
		store.publish()
	end, 8000)
end

return Auth
