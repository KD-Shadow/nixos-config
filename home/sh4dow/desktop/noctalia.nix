{ pkgs, inputs, ... }:

{
  programs.noctalia = {
    enable = true;
    settings = {
      accessibility = {
        ui_scale = 0.95;
      };

      bar = {
        order = [ "Sh4dow" "default" ];

        Sh4dow = {
          border = "on_primary";
          enabled = true;
          end = [
            "media"
            "tray"
            "notifications"
            "network"
            "volume"
            "battery"
          ];
          font_family = "JetBrainsMono NFM";
          margin_edge = 0;
          margin_ends = 0;
          position = "right";
          radius = 80;
          radius_bottom_left = 0;
          radius_bottom_right = 0;
          radius_top_left = 0;
          radius_top_right = 0;
          reserve_space = false;
          scale = 0.75;
          smart_auto_hide = true;
          start = [
            "workspaces"
            "audio_visualizer"
            "cat_2"
          ];
          widget_spacing = 11;
        };

        default = {
          background_opacity = 0.0;
          capsule = true;
          capsule_radius = 7;
          center = [ "clock" ];
          enabled = false;
          end = [ "group:g1" ];
          font_family = "JetBrainsMono NFM";
          margin_edge = 0;
          margin_ends = 92;
          position = "right";
          radius_bottom_left = 80;
          radius_bottom_right = 0;
          radius_top_left = 80;
          radius_top_right = 0;
          scale = 0.75;
          start = [ "group:g2" ];
          thickness = 34;

          capsule_group = [
            {
              accordion = true;
              accordion_direction = "end";
              border_width = 1.0;
              enabled = true;
              fill = "surface_variant";
              id = "g1";
              members = [
                "media"
                "tray"
                "notifications"
                "network"
                "volume"
                "battery"
              ];
              opacity = 1.0;
              padding = 12.0;
              widget_spacing = 9;
            }
            {
              accordion = false;
              accordion_direction = "end";
              border_width = 1.0;
              enabled = true;
              fill = "surface_variant";
              id = "g2";
              members = [
                "workspaces"
                "audio_visualizer"
                "cat"
              ];
              opacity = 1.0;
              padding = 15.0;
              widget_spacing = 10;
            }
          ];
        };
      };

      calendar = {
        enabled = true;
      };

      control_center = {
        calendar = {
          show_events_card = false;
        };
      };

      dock = {
        auto_hide = false;
        background_opacity = 0.0;
        enabled = true;
        icon_size = 29;
        launcher_icon = "brand-amigo";
        launcher_position = "start";
        layer = "overlay";
        main_axis_padding = 9;
        pinned = [ "Alacritty" "limusic" "helium" ];
        radius = 0;
        radius_top_left = 80;
        radius_top_right = 80;
        reserve_space = false;
        show_running = true;
        smart_auto_hide = true;
      };

      hot_corners = {
        bottom_left.action = "window_switcher";
        top_left.action = "launcher";
        top_right.action = "control_center";
      };

      idle = {
        behavior_order = [
          "lock"
          "screen-off"
          "lock-and-suspend"
        ];

        behavior = {
          lock = {
            action = "lock";
            enabled = true;
            timeout = 600.0;
          };

          lock-and-suspend = {
            action = "lock_and_suspend";
            enabled = true;
            timeout = 900.0;
          };

          screen-off = {
            action = "screen_off";
            enabled = true;
            timeout = 660.0;
          };
        };
      };

      lockscreen = {
        fingerprint = false;
      };

      notification = {
        background_opacity = 1.0;
        layer = "overlay";
        offset_x = 17;
        scale = 0.75;
      };

      shell = {
        app_icon_colorize = false;
        avatar_path = "/home/sh4dow/Pictures/Pics/anime(cat,girl).jpg";
        button_borders = false;
        card_borders = false;
        corner_radius_scale = 2.0;
        font_family = "JetBrainsMono NFM";
        input_borders = false;
        panel_anchor_bar = "Sh4dow";
        polkit_agent = true;
        popup_borders = false;
        settings_show_advanced = true;
        show_location = false;
        ui_scale = 0.9;

        panel = {
          borders = false;
          clipboard_placement = "attached";
          launcher_placement = "attached";
          polkit_placement = "attached";
        };

        screen_corners.size = 100;
      };

      theme = {
        builtin = "Tokyo-Night";
        community_palette = "Occult Umbral";
        mode = "dark";
        source = "community";
        wallpaper_scheme = "m3-content";

        templates = {
          builtin_ids = [
            "alacritty"
            "btop"
            "gtk3"
            "gtk4"
            "ghostty"
            "kitty"
            "qt"
            "starship"
          ];

          community_ids = [
            "libreoffice"
            "neovim"
            "zed"
            "fastfetch"
            "zathura"
            "bat"
            "herdr"
            "lazygit"
            "superfile"
            "surgedm"
          ];

          enable_builtin_templates = true;
          enable_community_templates = true;

        "nvim-base16" = {
          input_path = "~/.config/nvim/lua/matugen-template.lua";
          output_path = "~/.config/nvim/lua/matugen.lua";
          post_hook = "pkill -SIGUSR1 nvim";
        };
        user.limusic = {
            input_path = "/home/sh4dow/nixos-config/assets/templates/limusic.css";
            output_path = "/home/sh4dow/.config/limusic/matugen.css";
        };
          user.firefox = {
            input_path = "/home/sh4dow/nixos-config/assets/templates/firefox-colors.css";
            output_path = "/home/sh4dow/.config/mozilla/firefox/fmroyqzj.default/chrome/Colors.css";
          };
          user.strata = {
            input_path = "/home/sh4dow/nixos-config/assets/templates/strata-theme.toml";
            output_path = "/home/sh4dow/.config/strata/themes/noctalia.toml";
          };
          # user.librewolf = {
          #   input_path = "/home/sh4dow/nixos-config/assets/templates/firefox-colors.css";
          #   output_path = "/home/sh4dow/.config/librewolf/librewolf/1g1xx0q6.default/chrome/Colors.css";
          # };
        };
      };

      wallpaper = {
        directory = "/home/sh4dow/nixos-config/assets/wallpapers";
        transition_on_startup = true;

        automation = {
          enabled = false;
          interval_seconds = 300;
        };

        default.path =
          "/home/sh4dow/nixos-config/assets/wallpapers/wallhaven-d8vvlo.png";

        last.path =
          "/home/sh4dow/nixos-config/assets/wallpapers/wallhaven-d8vvlo.png";

        monitors.eDP-1.path =
          "/home/sh4dow/nixos-config/assets/wallpapers/wallhaven-d8vvlo.png";
      };

      weather.enabled = false;

      widget = {
        activity.type = "alexmnrs/github-activity:activity";
        cat.type = "dotnetrob/cat:cat";
        cat_2.type = "dotnetrob/cat:cat";
        clock.format = "{:%I:%M %p}";
        network.show_label = false;
        wallhaven.type = "noctalia/wallhaven:wallhaven";
        workspaces = {
          hide_when_empty = true;
          scale = 0.9;
        };
      };

      plugins = {
        enabled = [
          "noctalia/wallhaven"
          "dotnetrob/cat"
          "ashur-d/wallpaper-widget"
          "notoxus/media-island"
        ];

        source = [
          {
            auto_update = true;
            kind = "git";
            location = "https://github.com/noctalia-dev/official-plugins";
            name = "official";
          }
          {
            auto_update = true;
            kind = "git";
            location = "https://github.com/noctalia-dev/community-plugins";
            name = "community";
          }
        ];
      };

      plugin_settings = {
        "noctalia/wallhaven" = {
          browser_open_near_click = true;
          download_dir =
            "/home/sh4dow/nixos-config/assets/wallpapers";
        };
        "ashur-d/wallpaper-widget" = {
          close_on_apply = true;
          hub_layer = "overlay";
          hub_position = "bottom_center";
        };
        "notoxus/media-island" = {
          auto_show = false;
          preview_seconds = 1;
        };
      };

      templates = {
      };
    };
  };
}
