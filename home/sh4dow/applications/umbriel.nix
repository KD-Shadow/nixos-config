{ inputs, pkgs, ... }:

let
  umbrielBin = "${inputs.umbriel.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/umbriel";
  jqBin = "${pkgs.jq}/bin/jq";

  # https://docs.noctalia.dev/umbriel/streaming/
  sunshineOutputScript = pkgs.writeShellScript "umbriel-output.sh" ''
    set -eu

    name=sunshine

    case "$1" in
      create)
        ${umbrielBin} output-destroy "$name" >/dev/null 2>&1 || true
        ${umbrielBin} output-create "$name" \
          "''${SUNSHINE_CLIENT_WIDTH:-1920}x''${SUNSHINE_CLIENT_HEIGHT:-1080}@''${SUNSHINE_CLIENT_FPS:-60}" >/dev/null
        ;;
      remove)
        # Give the app's undo command up to 5 seconds to close its windows so
        # they do not flash onto a physical monitor.
        i=0
        while [ "$i" -lt 25 ]; do
          left="$(${umbrielBin} windows --json | ${jqBin} --arg out "$name:" \
            '[.[] | select(.workspace | startswith($out))] | length')"
          [ "$left" = 0 ] && break
          sleep 0.2
          i=$((i + 1))
        done

        # Move leftovers off the streamed output so they do not come back to
        # every future session when the output is recreated.
        target="$(${umbrielBin} workspaces --json | ${jqBin} -r --arg out "$name" \
          '[.[] | select(.output != $out and .active)]
           | (map(select(.focused)) + .) | first | "\(.name)/\(.output)" // empty')"
        for id in $(${umbrielBin} windows --json | ${jqBin} -r --arg out "$name:" \
          '.[] | select(.workspace | startswith($out)) | .id'); do
          [ -n "$target" ] || break
          ${umbrielBin} msg window-focus "$id"
          ${umbrielBin} msg window-move-to-workspace-silent "$target"
        done

        ${umbrielBin} output-destroy "$name" >/dev/null 2>&1 || true
        ;;
    esac
  '';
in
{
  imports = [ inputs.umbriel.homeModules.default ];

  # Consumed by services.sunshine.global_prep_cmd in hosts/sh4dow-umbriel.
  xdg.configFile."sunshine/umbriel-output.sh" = {
    source = sunshineOutputScript;
    executable = true;
  };

  programs.umbriel = {
    enable = true;
    settings = {
      # Ported from dotfiles/mango/mango-config/env.conf.
      environment = {
        GTK_IM_MODULE = "fcitx";
        QT_IM_MODULE = "fcitx";
        SDL_IM_MODULE = "fcitx";
        XMODIFIERS = "@im=fcitx";
        GLFW_IM_MODULE = "ibus";
        QT_QPA_PLATFORMTHEME = "qt6ct";
        QT_AUTO_SCREEN_SCALE_FACTOR = "1";
        QT_WAYLAND_FORCE_DPI = "140";
        QT_QPA_PLATFORM = "Wayland;xcb";
      };

      general = {
        # Noctalia is started by its systemd user service (see desktop/noctalia.nix).
        mod_key = "Super";
        xwayland = true;
        xwayland_native_resolution = false;
        show_cheatsheet = false;
        focus_on_activate = false;
        honor_restored_maximize = false;
      };

      input = {
        cursor = {
          theme = "capitaine-cursors";
          size = 24;
          hardware_cursor = true;
          follows_focus = false;
          hide_when_typing = false;
          hide_timeout_ms = 0;
        };

        # From mango's repeat_rate/repeat_delay/numlock_on/xkb_rules_options.
        keyboard = {
          repeat_rate = 25;
          repeat_delay = 600;
          numlock_toggle = true;
          options = "caps:escape";
        };

        # mango: sloppy_focus = 1.
        focus.follows_mouse = "sloppy";
      };

      keybinds = {
        # Config
        "Mod+Shift+R" = "config-reload";

        # Applications
        "Mod+Return" = "spawn alacritty";
        "Mod+Shift+Return" = "spawn ghostty --title=ghostty-float";
        "Mod+B" = "spawn firefox";
        "Mod+E" = "spawn strata";
        "Mod+F" = "spawn superfile";

        # Power
        "Mod+Alt+Ctrl+P" = "spawn systemctl poweroff";
        "Mod+Alt+Ctrl+R" = "spawn systemctl reboot";

        # Windows
        "Mod+Q" = "window-close";
        "Mod+U" = "window-focus-last";
        "Alt+Left" = "window-focus-left";
        "Alt+Right" = "window-focus-right";
        "Alt+Up" = "window-focus-up";
        "Alt+Down" = "window-focus-down";
        "Alt+F" = "window-toggle-fullscreen";
        "Alt+A" = "window-toggle-floating";
        "Alt+Z" = "window-toggle-scratchpad";
        "Mod+I" = "overview-toggle";
        "Mod+O" = "overview-toggle";

        # From mango's exchange/resize/move binds.
        "Mod+Shift+Up" = "window-move-up";
        "Mod+Shift+Down" = "window-move-down";
        "Ctrl+Shift+Up" = "window-move-by 0 -50";
        "Ctrl+Shift+Down" = "window-move-by 0 +50";
        "Ctrl+Shift+Left" = "window-move-by -50 +0";
        "Ctrl+Shift+Right" = "window-move-by +50 +0";
        "Ctrl+Alt+H" = "window-modify-width-left -0.02";
        "Ctrl+Alt+L" = "window-modify-width-right +0.02";
        "Mod+G" = "workspace-toggle-show-desktop";

        # Workspaces
        "Mod+Left" = "workspace-previous";
        "Mod+Right" = "workspace-next";
        "Mod+Shift+Left" = "column-move-to-workspace-previous";
        "Mod+Shift+Right" = "column-move-to-workspace-next";
        "Mod+1" = "workspace-switch 1";
        "Mod+2" = "workspace-switch 2";
        "Mod+3" = "workspace-switch 3";
        "Mod+4" = "workspace-switch 4";
        "Mod+5" = "workspace-switch 5";
        "Mod+6" = "workspace-switch 6";
        "Mod+7" = "workspace-switch 7";
        "Mod+8" = "workspace-switch 8";
        "Mod+9" = "workspace-switch 9";
        "Mod+Shift+1" = "window-move-to-workspace-silent 1";
        "Mod+Shift+2" = "window-move-to-workspace-silent 2";
        "Mod+Shift+3" = "window-move-to-workspace-silent 3";
        "Mod+Shift+4" = "window-move-to-workspace-silent 4";
        "Mod+Shift+5" = "window-move-to-workspace-silent 5";
        "Mod+Shift+6" = "window-move-to-workspace-silent 6";
        "Mod+Shift+7" = "window-move-to-workspace-silent 7";
        "Mod+Shift+8" = "window-move-to-workspace-silent 8";
        "Mod+Shift+9" = "window-move-to-workspace-silent 9";

        # Layout switching (mango's switch_layout / setlayout binds).
        "Mod+N" = "workspace-set-layout toggle scrolling master";
        "Ctrl+Mod+I" = "workspace-set-layout scrolling";
        "Ctrl+Mod+L" = "workspace-set-layout master";

        # Monitor focus/movement (mango focusmon / tagmon).
        "Alt+Shift+Left" = "output-focus-left";
        "Alt+Shift+Right" = "output-focus-right";
        "Alt+Shift+Up" = "output-focus-up";
        "Alt+Shift+Down" = "output-focus-down";
        "Mod+Alt+Left" = "window-move-to-output-left";
        "Mod+Alt+Right" = "window-move-to-output-right";
        "Mod+Alt+Up" = "window-move-to-output-up";
        "Mod+Alt+Down" = "window-move-to-output-down";

        # Audio
        "XF86AudioRaiseVolume" = "spawn wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
        "XF86AudioLowerVolume" = "spawn wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        "XF86AudioMute" = "spawn wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        "XF86AudioPlay" = "spawn noctalia msg media toggle";
        "XF86AudioNext" = "spawn noctalia msg media next";
        "XF86AudioPrev" = "spawn noctalia msg media previous";
        "Mod+Shift+Plus" = "spawn wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
        "Mod+Shift+Minus" = "spawn wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";

        # Brightness
        "XF86MonBrightnessUp" = "spawn brightnessctl set +5%";
        "XF86MonBrightnessDown" = "spawn brightnessctl set 5%-";

        # Noctalia shell and plugins
        "Mod+Comma" = "spawn noctalia msg settings-toggle";
        "Mod+Space" = "spawn noctalia msg panel-toggle launcher";
        "Mod+V" = "spawn noctalia msg panel-toggle clipboard";
        "Mod+W" = "spawn noctalia msg panel-toggle wallpaper";
        "Mod+Shift+W" = "spawn noctalia msg panel-toggle ishan0121/wallpaper-deck:picker";
        "Mod+P" = "spawn noctalia msg screenshot-region";
        "Mod+Alt+S" = "spawn noctalia msg screenshot-region";
        "Mod+S" = "spawn noctalia msg panel-toggle control-center";
        "Mod+Escape" = "spawn noctalia msg panel-toggle session";
        "Mod+L" = "spawn noctalia msg session lock";
        "Mod+Shift+Tab" = "spawn noctalia msg window-switcher";
        "Mod+Shift+D" = "spawn noctalia msg panel-toggle aristides/udiskie:manager";
        "Mod+Alt+C" = "spawn noctalia msg panel-toggle yuuto/calculator:panel";
        "Mod+Alt+T" = "spawn noctalia msg panel-toggle lepinx/typer:test";
        "Mod+M" = "spawn noctalia msg panel-toggle sh4dow/yt-music:panel";
        "Mod+Alt+M" = "spawn noctalia msg panel-toggle sh4dow/yt-music:mini";
        "Mod+Shift+M" = "spawn noctalia msg plugin sh4dow/yt-music:service all toggle";
        "Mod+Alt+W" = "spawn noctalia msg panel-toggle noctalia/wallhaven:browser";
        "Mod+Alt+Space" = "spawn noctalia msg panel-toggle theblackdon/theme-switcher:carousel";
      };

      # Mango used scrolling + tile tags; Umbriel's scrolling layout is the
      # closest tiling equivalent. Gaps and extents come from animations.conf.
      layout = {
        mode = "scrolling";
        gap = 5;
        extent_presets = [ 0.5 0.8 1.0 ];
        scrolling.default_extent_fraction = 0.8;
        master = {
          default_width_fraction = 0.55;
          new_becomes_master = true;
        };
      };

      appearance = {
        prefer_no_csd = true;
        border_width = 1;
        outer_border_width = 0;
        corner_radius = 10;
        drag_opacity = 0.8;
        opaque_fullscreen = true;

        tab_bar = {
          style = "titles";
          position = "top";
          height = 24;
          font = "JetBrainsMono Nerd Font Mono 10";
          padding = 8;
          tab_gap = 2;
          corner_radius = -1;
          title_format = "{title}";
          title_align = "center";
          visible = true;
          hide_when_single = false;
          max_tabs = 0;
          overflow = "scroll";
        };

        blur = {
          enabled = true;
          optimized = true;
          passes = 1;
          radius = 7;
          noise = 0.05;
          brightness = 0.9;
          contrast = 0.9;
          # Mango used 3, but Umbriel caps saturation at 2.
          saturation = 2.0;
        };

        shadow = {
          enabled = true;
          softness = 15;
          offset_x = 0;
          offset_y = 0;
        };
      };

      # Timings mapped from mango's animation_duration_* values. Umbriel does
      # not accept mango's non-monotonic Bezier curves, so use its own easing.
      animation = {
        enabled = true;
        duration_ms = 400;
        curve = "easeout";
        windows_in = {
          enabled = true;
          style = "zoom";
          scale = 0.3;
          duration_ms = 400;
        };
        windows_out = {
          enabled = true;
          style = "slide";
          duration_ms = 800;
        };
        windows_move = {
          enabled = true;
          duration_ms = 500;
        };
        windows_resize = {
          enabled = true;
          duration_ms = 500;
        };
        windows_opacity = {
          enabled = true;
          duration_ms = 400;
        };
        workspaces = {
          enabled = true;
          style = "slide";
          duration_ms = 350;
        };
        layers.enabled = true;
      };

      # From dotfiles/mango/mango-config/rule.conf, plus the Noctalia layer
      # blur rules and the streaming rules from the Umbriel docs.
      window_rule = [
        {
          match.is_focused = true;
          opacity = 0.8;
        }
        {
          match.is_focused = false;
          opacity = 0.9;
        }
        {
          match.app_id = [ "^brave$" "^helium$" ];
          default_workspace = 3;
          opacity = 1.0;
        }
        {
          match.app_id = "^firefox$";
          default_workspace = 3;
          match.is_focused = true;
          opacity = 0.95;
        }
        {
          match.app_id = "^limusic$";
          default_workspace = 4;
        }
        {
          match.app_id = "^mpv$";
          default_workspace = 5;
          default_floating = true;
          blur = false;
          opacity = 1.0;
        }
        {
          match.app_id = "^nwg-look$";
          default_floating = true;
        }
        {
          match.app_id = "^ghostty$";
          match.title = [ "^ghostty-float$" "^ghostty-cliamp$" ];
          default_floating = true;
        }
        {
          match.app_id = "^org[.]gnome[.]eog$";
          default_floating = true;
          opacity = 1.0;
        }
        {
          match.app_id = "^pcmanfm$";
          default_floating = true;
          default_floating_size_px = { width = 700; height = 700; };
        }

        # https://docs.noctalia.dev/umbriel/streaming/
        {
          match.app_id = "^steam$";
          match.title = "[Bb]ig [Pp]icture";
          default_output = "sunshine";
          default_fullscreen = true;
        }
        {
          match.app_id = "^steam_app_";
          default_output = "sunshine";
          confine_pointer = true;
        }
      ];

      layer_rule = [
        {
          match.namespace = "rofi";
          blur = true;
        }
        {
          match.namespace = "^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd|desktop-widget-[^\"]*)$";
          blur = true;
          blur_ignore_alpha = 0.5;
          blur_popups = true;
        }
        {
          match.namespace = "^noctalia-(notification|dock|panel|attached-panel|osd)$";
          blur_optimized = false;
        }
      ];

      # mango's hotarea_size/enable_hotarea.
      hot_corners.top_left = {
        enabled = true;
        delay_ms = 500;
        action = "overview-open";
      };
    };
  };
}
