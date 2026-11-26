{ inputs, ... }:

{
  imports = [ inputs.umbriel.homeModules.default ];

  programs.umbriel = {
    enable = true;
    settings = {
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

        keyboard = {
          repeat_rate = 25;
          repeat_delay = 600;
          numlock_toggle = true;
          options = "caps:escape";
        };

        focus.follows_mouse = "sloppy";
      };

      keybinds = {
        # Config
        "Mod+Shift+R" = "config-reload";

        # Applications
        "Mod+Return" = "spawn ghostty";
        "Mod+Shift+Return" = "spawn ghostty --title=ghostty-float";
        "Mod+F" = "spawn ghostty -e superfile";
        "Mod+Alt+N" = "spawn neovide";
        "Mod+Shift+T" = "spawn ghostty --title=ghostty-cliamp -e smassh";
        "Mod+B" = "spawn firefox";
        "Mod+E" = "spawn strata";

        # Power
        "Mod+Alt+Ctrl+P" = "spawn systemctl poweroff";
        "Mod+Alt+Ctrl+R" = "spawn systemctl reboot";

        # Window focus
        "Mod+Q" = "window-close";
        "Mod+Tab" = "window-focus-next";
        "Mod+U" = "window-focus-last";
        "Alt+Left" = "window-focus-left";
        "Alt+Right" = "window-focus-right";
        "Alt+Up" = "window-focus-up";
        "Alt+Down" = "window-focus-down";
        "Alt+H" = "window-focus-left";
        "Alt+J" = "window-focus-down";
        "Alt+K" = "window-focus-up";
        "Alt+L" = "window-focus-right";

        # exchange_client
        "Mod+Shift+Up" = "window-swap-up";
        "Mod+Shift+Down" = "window-swap-down";
        "Mod+Shift+Left" = "window-swap-left";
        "Mod+Shift+Right" = "window-swap-right";

        # movewin (logical pixels)
        "Ctrl+Shift+Up" = "window-move-by 0 -50";
        "Ctrl+Shift+Down" = "window-move-by 0 +50";
        "Ctrl+Shift+Left" = "window-move-by -50 +0";
        "Ctrl+Shift+Right" = "window-move-by +50 +0";

        # resizewin (fractions of the usable area)
        "Ctrl+Alt+K" = "window-modify-height-down -0.02";
        "Ctrl+Alt+J" = "window-modify-height-down +0.02";
        "Ctrl+Alt+H" = "window-modify-width-left -0.02";
        "Ctrl+Alt+L" = "window-modify-width-right +0.02";

        # Window states. Umbriel's pinned state covers both mango's global
        # (all tags) and overlay (always on top) states.
        "Mod+G" = "window-toggle-pinned";
        "Alt+Tab" = "overview-toggle";
        "Alt+A" = "window-toggle-floating";
        "Alt+F" = "window-toggle-fullscreen";
        "Alt+Shift+F" = "window-toggle-maximize-to-edges";
        "Mod+I" = "window-minimize";
        "Mod+Shift+I" = "window-restore-minimized";
        "Mod+O" = "window-toggle-pinned";
        "Alt+Z" = "window-toggle-scratchpad";

        # Scroller layout proportions
        "Alt+E" = "window-set-primary-extent 1.0";
        "Alt+X" = "window-cycle-primary-extent";

        # Tile layout. Mango's zoom swaps with the master; Umbriel has no
        # targeted master swap, so step toward it in layout order.
        "Mod+Shift+E" = "layout-master-count-increase";
        "Alt+S" = "window-swap-previous";

        # Layout switching: mango tile/scroller are Umbriel master/scrolling.
        "Mod+N" = "workspace-set-layout toggle scrolling master";
        "Ctrl+Mod+I" = "workspace-set-layout master";
        "Ctrl+Mod+L" = "workspace-set-layout scrolling";

        "Mod+Left" = "workspace-previous";
        "Mod+Right" = "workspace-next";
        "Ctrl+Left" = "workspace-previous";
        "Ctrl+Right" = "workspace-next";

        # Move window to workspace (mango tagtoleft/tagtoright and toggletag).
        "Ctrl+Mod+Left" = "window-move-to-workspace-previous";
        "Ctrl+Mod+Right" = "window-move-to-workspace-next";
        "Ctrl+Mod+1" = "window-move-to-workspace-silent 1";
        "Ctrl+Mod+2" = "window-move-to-workspace-silent 2";
        "Ctrl+Mod+3" = "window-move-to-workspace-silent 3";
        "Ctrl+Mod+4" = "window-move-to-workspace-silent 4";
        "Ctrl+Mod+5" = "window-move-to-workspace-silent 5";
        "Ctrl+Mod+6" = "window-move-to-workspace-silent 6";
        "Ctrl+Mod+7" = "window-move-to-workspace-silent 7";
        "Ctrl+Mod+8" = "window-move-to-workspace-silent 8";
        "Ctrl+Mod+9" = "window-move-to-workspace-silent 9";

        # Direct workspace
        "Mod+1" = "workspace-switch 1";
        "Mod+2" = "workspace-switch 2";
        "Mod+3" = "workspace-switch 3";
        "Mod+4" = "workspace-switch 4";
        "Mod+5" = "workspace-switch 5";
        "Mod+6" = "workspace-switch 6";
        "Mod+7" = "workspace-switch 7";
        "Mod+8" = "workspace-switch 8";
        "Mod+9" = "workspace-switch 9";

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
        "Mod+W" = "spawn noctalia msg panel-toggle ashur-d/wallpaper-widget:hub";
        "Mod+Alt+S" = "spawn noctalia msg screenshot-region";
        "Mod+S" = "spawn noctalia msg panel-toggle control-center [tab]";
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

        "Alt+MouseMiddle" = "window-set-primary-extent 0.5";
        "Mod+Ctrl+MouseLeft" = "window-minimize";
        "Mod+Ctrl+MouseRight" = "window-close";
        "Mod+Ctrl+MouseMiddle" = "window-toggle-fullscreen";

        "Mod+WheelUp" = { action = "workspace-previous"; cooldown_ms = 150; };
        "Mod+WheelDown" = { action = "workspace-next"; cooldown_ms = 150; };
        "Alt+WheelUp" = "window-focus-left";
        "Alt+WheelDown" = "window-focus-right";
        "Mod+Shift+WheelUp" = "window-swap-left";
        "Mod+Shift+WheelDown" = "window-swap-right";

      };

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
        border_width = 0;
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
          saturation = 2.0;
        };

        shadow = {
          enabled = true;
          softness = 15;
          offset_x = 0;
          offset_y = 0;
        };
      };

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
          default_maximize_to_edges = true;
          match.is_focused = true;
          opacity = 1.0;
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

      hot_corners.top_left = {
        enabled = true;
        delay_ms = 500;
        action = "overview-open";
      };
    };
  };
}
