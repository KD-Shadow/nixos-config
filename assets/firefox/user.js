user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
/*** [SECTION 0] STARTUP & NEW TAB NOISE ***/
user_pref("browser.startup.homepage_override.mstone", "ignore");
user_pref("browser.newtabpage.activity-stream.feeds.telemetry", false);
user_pref("browser.newtabpage.activity-stream.telemetry", false);
user_pref("browser.newtabpage.activity-stream.showSponsored", false);
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);
user_pref("browser.newtabpage.activity-stream.default.sites", "");
user_pref("extensions.pocket.enabled", false);

/*** [SECTION 1] TELEMETRY, STUDIES, CRASH REPORTS ***/
user_pref("datareporting.policy.dataSubmissionEnabled", false);
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("toolkit.telemetry.unified", false);
user_pref("toolkit.telemetry.enabled", false);
user_pref("toolkit.telemetry.server", "data:,");
user_pref("toolkit.telemetry.archive.enabled", false);
user_pref("toolkit.telemetry.newProfilePing.enabled", false);
user_pref("toolkit.telemetry.shutdownPingSender.enabled", false);
user_pref("toolkit.telemetry.updatePing.enabled", false);
user_pref("toolkit.telemetry.bhrPing.enabled", false);
user_pref("toolkit.telemetry.firstShutdownPing.enabled", false);
user_pref("toolkit.telemetry.coverage.opt-out", true);
user_pref("toolkit.coverage.opt-out", true);
user_pref("toolkit.coverage.endpoint.base", "");
user_pref("app.shield.optoutstudies.enabled", false);
user_pref("app.normandy.enabled", false);
user_pref("app.normandy.api_url", "");
user_pref("breakpad.reportURL", "");
user_pref("browser.tabs.crashReporting.sendReport", false);
user_pref("browser.crashReports.unsubmittedCheck.autoSubmit2", false);
user_pref("browser.ping-centre.telemetry", false);
user_pref("messaging-system.rsexperimentloader.enabled", false);

/*** [SECTION 2] AI / ML FEATURES ***/
user_pref("browser.ml.enable", false);
user_pref("browser.ml.chat.enabled", false);
user_pref("browser.ml.chat.sidebar", false);
user_pref("browser.ml.chat.shortcuts", false);
user_pref("browser.ml.linkPreview.enabled", false);
user_pref("browser.tabs.groups.smart.enabled", false);

/*** [SECTION 3] NETWORK: NO SPECULATIVE CONNECTIONS / PREFETCH ***/
user_pref("network.prefetch-next", false);
user_pref("network.dns.disablePrefetch", true);
user_pref("network.dns.disablePrefetchFromHTTPS", true);
user_pref("network.predictor.enabled", false);
user_pref("network.predictor.enable-prefetch", false);
user_pref("network.http.speculative-parallel-limit", 0);
user_pref("browser.urlbar.speculativeConnect.enabled", false);
user_pref("browser.places.speculativeConnect.enabled", false);
user_pref("beacon.enabled", false);
user_pref("browser.send_pings", false);
user_pref("network.IDN_show_punycode", true); // anti-homograph phishing
user_pref("network.gio.supported-protocols", ""); // linux: no gvfs protocol handlers
user_pref("network.file.disable_unc_paths", true);

/*** [SECTION 4] DNS OVER HTTPS ***/
// Mode 2 = use DoH, fall back to system DNS if it fails (no breakage).
// Mode 3 = DoH only (stricter, can break on captive portals / some networks).
user_pref("network.trr.mode", 2);
// [OPTIONAL] pick your own resolver instead of Firefox's default:
// user_pref("network.trr.uri", "https://dns.quad9.net/dns-query");
// user_pref("network.trr.custom_uri", "https://dns.quad9.net/dns-query");

/*** [SECTION 5] HTTPS / TLS ***/
user_pref("dom.security.https_only_mode", true); // warns before falling back to http
user_pref("dom.security.https_only_mode_send_http_background_request", false);
user_pref("security.ssl.require_safe_negotiation", true);
user_pref("security.tls.enable_0rtt_data", false);
user_pref("security.ssl.treat_unsafe_negotiation_as_broken", true);
user_pref("security.mixed_content.block_display_content", true);
user_pref("security.csp.reporting.enabled", false);
user_pref(
  "network.http.referer.disallowCrossSiteRelaxingDefault.top_navigation",
  true,
);
user_pref("network.dns.echconfig.enabled", true); // Encrypted Client Hello
user_pref("network.dns.http3_echconfig.enabled", true);
user_pref("security.pki.crlite_mode", 2); // revocation checking via CRLite
user_pref("security.remote_settings.crlite_filters.enabled", true);

/*** [SECTION 6] SAFE BROWSING (kept ON on purpose) ***/
// Uses local lists; Firefox does not send full URLs to Google.
// Only the extra "check downloads remotely" is turned off.
user_pref("browser.safebrowsing.malware.enabled", true);
user_pref("browser.safebrowsing.phishing.enabled", true);
user_pref("browser.safebrowsing.downloads.enabled", true);
user_pref("browser.safebrowsing.downloads.remote.enabled", false);

/*** [SECTION 7] TRACKING PROTECTION, COOKIES, REFERRERS ***/
user_pref("browser.contentblocking.category", "strict");
user_pref("network.cookie.cookieBehavior", 5); // Total Cookie Protection
user_pref("privacy.trackingprotection.enabled", true);
user_pref("privacy.trackingprotection.socialtracking.enabled", true);
user_pref("privacy.trackingprotection.cryptomining.enabled", true);
user_pref("privacy.trackingprotection.fingerprinting.enabled", true);
user_pref("privacy.trackingprotection.emailtracking.enabled", true);
user_pref("privacy.query_stripping.enabled", true);
user_pref("privacy.query_stripping.enabled.pbmode", true);
user_pref("privacy.globalprivacycontrol.enabled", true);
user_pref("privacy.donottrackheader.enabled", false); // DNT is itself a fingerprinting bit; GPC covers it
user_pref("network.http.referer.XOriginTrimmingPolicy", 2); // cross-origin: send origin only
user_pref("privacy.partition.network_state.ocsp_cache", true);

/*** [SECTION 8] FINGERPRINTING (light, low-breakage) ***/
// FPP = fingerprinting protection in strict mode, much less breakage than
// privacy.resistFingerprinting (which changes timezone, forces light theme,
// rounds window size, etc). Use RFP only if you accept that.
user_pref("privacy.fingerprintingProtection", true);
// [OPTIONAL] full arkenfox-style RFP:
// user_pref("privacy.resistFingerprinting", true);
// user_pref("privacy.window.maxInnerWidth", 1600);
// user_pref("privacy.window.maxInnerHeight", 900);
user_pref("webgl.disable-fail-if-major-performance-caveat", true);
user_pref("media.navigator.enabled", false); // no camera/mic enumeration without a prompt
user_pref("dom.battery.enabled", false);

/*** [SECTION 9] WEBRTC IP LEAK PROTECTION ***/
// WebRTC stays enabled (video calls work) but won't expose local/LAN IPs.
user_pref("media.peerconnection.ice.default_address_only", true);
user_pref("media.peerconnection.ice.no_host", true);
user_pref("media.peerconnection.ice.proxy_only_if_behind_proxy", true);

/*** [SECTION 10] GEOLOCATION / PERMISSIONS ***/
user_pref(
  "geo.provider.network.url",
  "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%",
);
user_pref("geo.provider.use_geoclue", false);
user_pref("permissions.default.geo", 0); // always ask
user_pref("permissions.manager.defaultsUrl", "");
user_pref("permissions.delegation.enabled", false); // iframes can't inherit permissions
user_pref("dom.push.enabled", false); // no push notifications
user_pref("dom.push.connection.enabled", false);
user_pref("dom.push.serverURL", "");
user_pref("dom.vr.enabled", false);
user_pref("dom.webaudio.enabled", true);

/*** [SECTION 11] URL BAR & SEARCH ***/
user_pref("browser.urlbar.suggest.searches", false);
user_pref("browser.search.suggest.enabled", false);
user_pref("browser.urlbar.suggest.quicksuggest.nonsponsored", false);
user_pref("browser.urlbar.suggest.quicksuggest.sponsored", false);
user_pref("browser.urlbar.quicksuggest.enabled", false);
user_pref("browser.urlbar.trending.featureGate", false);
user_pref("browser.urlbar.suggest.trending", false);
user_pref("browser.urlbar.groupLabels.enabled", false);
user_pref("browser.urlbar.showSearchSuggestionsFirst", false);
user_pref("browser.formfill.enable", false); // no search/form history
user_pref("browser.search.separatePrivateDefault.ui.enabled", true);
user_pref("keyword.enabled", true); // keep: search from the URL bar still works

/*** [SECTION 12] PASSWORDS & AUTOFILL ***/
// Built-in password manager stays ON. Add a primary password in Settings -> Privacy.
user_pref("signon.autofillForms", false); // don't autofill login forms on page load
user_pref("signon.formlessCapture.enabled", false);
user_pref("signon.generation.enabled", true);
user_pref("signon.privateBrowsingCapture.enabled", false);
user_pref("network.auth.subresource-http-auth-strategy", 1);
user_pref("extensions.formautofill.addresses.enabled", false);
user_pref("extensions.formautofill.creditCards.enabled", false);
user_pref("browser.contentblocking.report.lockwise.enabled", false);
user_pref("browser.contentblocking.report.monitor.enabled", false);
user_pref("browser.contentblocking.report.proxy.enabled", false);

/*** [SECTION 13] DISK AVOIDANCE / SESSION ***/
user_pref("browser.cache.disk.enable", false); // RAM cache only
user_pref("browser.privatebrowsing.forceMediaMemoryCache", true);
user_pref("media.memory_cache_max_size", 65536);
user_pref("browser.sessionstore.privacy_level", 2); // don't store form data / session cookies in sessionstore
user_pref("browser.shell.shortcutFavicons", false);
// [OPTIONAL] wipe things when Firefox closes (will log you out of sites):
// user_pref("privacy.sanitize.sanitizeOnShutdown", true);
// user_pref("privacy.clearOnShutdown_v2.cookiesAndStorage", true);
// user_pref("privacy.clearOnShutdown_v2.historyFormDataAndDownloads", true);
// user_pref("privacy.clearOnShutdown_v2.cache", true);

/*** [SECTION 14] PDF, DOWNLOADS, EXTENSIONS ***/
user_pref("pdfjs.enableScripting", false); // no JavaScript inside PDFs
user_pref("browser.download.useDownloadDir", false); // ask where to save
user_pref("browser.download.alwaysOpenPanel", false);
user_pref("browser.download.manager.addToRecentDocs", false);
user_pref("extensions.getAddons.showPane", false);
user_pref("extensions.htmlaboutaddons.recommendations.enabled", false);
user_pref("extensions.postDownloadThirdPartyPrompt", false);
user_pref("extensions.webcompat-reporter.enabled", false);
user_pref("extensions.enabledScopes", 5); // only profile + app scopes; no sideloaded system extensions
user_pref("extensions.autoDisableScopes", 15);

/*** [SECTION 15] MISC HARDENING ***/
user_pref("dom.security.sanitizer.enabled", true);
user_pref("dom.event.clipboardevents.enabled", true); // keep: some sites need it; false breaks copy/paste UIs
user_pref("browser.uitour.enabled", false);
user_pref("browser.uitour.url", "");
user_pref("devtools.chrome.enabled", false);
user_pref("devtools.debugger.remote-enabled", false);
user_pref("network.captive-portal-service.enabled", false); // stops background requests to Mozilla
user_pref("network.connectivity-service.enabled", false);
user_pref("browser.region.network.url", "");
user_pref("browser.region.update.enabled", false);
user_pref("doh-rollout.disable-heuristics", true);
user_pref("media.gmp-gmpopenh264.enabled", true); // keep; WebRTC video depends on it
// DRM left ON so Netflix/Prime/Spotify work. [OPTIONAL] to disable:
// user_pref("media.eme.enabled", false);
// user_pref("browser.eme.ui.enabled", false);

/*** END ***/
