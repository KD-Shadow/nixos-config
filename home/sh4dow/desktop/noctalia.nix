{ config, ... }:

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
          background_opacity = 0.9;
          border = "on_primary";
          center = [ "clock" "theme-switcher" ];
          enabled = true;
          end = [ "media" "tray" "cpu" "notifications" "network" "volume" "battery" ];
          font_family = "JetBrainsMono NFM";
          margin_edge = 0;
          margin_ends = 0;
          position = "top";
          radius = 80;
          radius_bottom_left = 0;
          radius_bottom_right = 0;
          radius_top_left = 0;
          radius_top_right = 0;
          reserve_space = false;
          scale = 0.75;
          smart_auto_hide = true;
          start = [ "workspaces" "audio_visualizer" "cat_2" ];
          widget_spacing = 11;
        };
        default = {
          background_opacity = 0.42;
          capsule = true;
          capsule_radius = 7;
          center = [ "clock" ];
          enabled = false;
          end = [ "group:g1" ];
          font_family = "JetBrainsMono NFM";
          margin_edge = 3;
          margin_ends = 92;
          position = "right";
          radius = 80;
          radius_bottom_left = 0;
          radius_bottom_right = 0;
          radius_top_left = 0;
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
              members = [ "media" "tray" "notifications" "network" "volume" "battery" ];
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
              members = [ "workspaces" "audio_visualizer" "cat" ];
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
        hidden_tabs = [ "bluetooth" ];
        calendar = {
          show_events_card = false;
        };
      };
      desktop_widgets = {
        schema_version = 2;
        widget_order = [
          "desktop-widget-0000000000000001"
          "desktop-widget-0000000000000002"
          "desktop-widget-0000000000000003"
        ];
        grid = {
          cell_size = 16;
          major_interval = 4;
          visible = true;
        };
        widget = {
          "desktop-widget-0000000000000002" = {
            box_height = 144.0;
            box_width = 320.0;
            cx = 160.0;
            cy = 88.0;
            output = "eDP-1";
            placement_height = 768.0;
            placement_width = 1366.0;
            rotation = 0.0;
            type = "clock";
            settings = {
              background = false;
              center_text = true;
              clock_style = "digital";
              font_family = "";
              format = "{:%I:%M %p}";
              shadow = true;
            };
          };
          "desktop-widget-0000000000000003" = {
            box_height = 0.0;
            box_width = 0.0;
            cx = 171.0;
            cy = 622.5;
            output = "eDP-1";
            placement_height = 768.0;
            placement_width = 1366.0;
            rotation = 0.0;
            type = "fancy_audio_visualizer";
            settings = {
              background = false;
              bar_width = 1.0;
              bloom_intensity = 0.65;
              inner_diameter = 1.0;
              primary_color = "primary";
              ring_opacity = 1.0;
              rotation_speed = 1.3;
              sensitivity = 3.0;
              visualization_mode = "bars_rings";
            };
          };
        };
      };
      dock = {
        auto_hide = false;
        background_opacity = 1.0;
        enabled = true;
        icon_size = 23;
        launcher_icon = "brand-amigo";
        launcher_position = "start";
        layer = "overlay";
        magnification_scale = 1.65;
        main_axis_padding = 9;
        pinned = [ "Alacritty" "helium" "firefox" "limusic" ];
        radius = 0;
        radius_top_left = 80;
        radius_top_right = 80;
        reserve_space = false;
        show_dots = true;
        show_running = true;
        smart_auto_hide = true;
      };
      hot_corners = {
        bottom_left = {
          action = "window_switcher";
        };
        top_left = {
          action = "launcher";
        };
        top_right = {
          action = "control_center";
        };
      };
      idle = {
        behavior_order = [ "lock" "screen-off" "lock-and-suspend" ];
        behavior = {
          lock = {
            action = "lock";
            enabled = true;
            timeout = 600.0;
          };
          "lock-and-suspend" = {
            action = "lock_and_suspend";
            enabled = true;
            timeout = 900.0;
          };
          "screen-off" = {
            action = "screen_off";
            enabled = true;
            timeout = 660.0;
          };
        };
      };
      lockscreen = {
        fingerprint = false;
      };
      lockscreen_widgets = {
        enabled = true;
        schema_version = 2;
        widget_order = [
          "lockscreen-widget-0000000000000009"
          "lockscreen-widget-0000000000000005"
          "lockscreen-widget-0000000000000006"
          "lockscreen-login-box@eDP-1"
          "lockscreen-widget-0000000000000001"
          "lockscreen-widget-0000000000000002"
          "lockscreen-widget-0000000000000003"
          "lockscreen-widget-0000000000000004"
          "lockscreen-widget-0000000000000008"
        ];
        grid = {
          cell_size = 16;
          major_interval = 4;
          visible = false;
        };
        widget = {
          "lockscreen-login-box@eDP-1" = {
            box_height = 196.0;
            box_width = 810.0;
            cx = 683.0;
            cy = 658.0;
            output = "eDP-1";
            placement_height = 768.0;
            placement_width = 1366.0;
            rotation = 0.0;
            type = "login_box";
            settings = {
              background_color = "surface_variant";
              background_opacity = 0.88;
              background_radius = 12.0;
              center_password_text = true;
              input_opacity = 1.0;
              input_radius = 6.0;
              layout = "regular";
              show_caps_lock = true;
              show_keyboard_layout = true;
              show_login_button = true;
              show_media = true;
              show_session_buttons = true;
              show_unlock_hint = false;
              show_weather = true;
            };
          };
          "lockscreen-widget-0000000000000001" = {
            box_height = 144.0;
            box_width = 816.0;
            cx = 683.0;
            cy = 487.54296875;
            output = "eDP-1";
            placement_height = 768.0;
            placement_width = 1366.0;
            rotation = 0.0;
            type = "audio_visualizer";
            settings = {
              background = false;
              bands = 128;
              centered = false;
              mirrored = true;
              reversed = false;
              show_when_idle = true;
            };
          };
          "lockscreen-widget-0000000000000002" = {
            box_height = 112.0;
            box_width = 224.0;
            cx = 667.0;
            cy = 168.0;
            output = "eDP-1";
            placement_height = 768.0;
            placement_width = 1366.0;
            rotation = 0.0;
            type = "clock";
            settings = {
              background = false;
              format = "{:%H:%M}";
            };
          };
          "lockscreen-widget-0000000000000003" = {
            box_height = 96.0;
            box_width = 160.0;
            cx = 779.0;
            cy = 298.5;
            output = "eDP-1";
            placement_height = 768.0;
            placement_width = 1366.0;
            rotation = 0.0;
            type = "sysmon";
            settings = {
              background_color = "shadow";
              display = "graph";
              gauge_layout = "vertical";
              stat = "cpu_usage";
              stat2 = "cpu_temp";
            };
          };
          "lockscreen-widget-0000000000000004" = {
            box_height = 112.0;
            box_width = 128.0;
            cx = 75.0;
            cy = 72.0;
            output = "eDP-1";
            placement_height = 768.0;
            placement_width = 1366.0;
            rotation = 0.0;
            type = "sticker";
            settings = {
              background = false;
              image_path = "${config.home.homeDirectory}/Pictures/fc6ed898-5da2-4459-b0f8-87d04e45b5da-removebg-preview.png";
              opacity = 1.0;
            };
          };
          "lockscreen-widget-0000000000000005" = {
            box_height = 304.0;
            box_width = 432.0;
            cx = 663.69140625;
            cy = 242.25;
            output = "eDP-1";
            placement_height = 768.0;
            placement_width = 1366.0;
            rotation = 0.0;
            type = "label";
            settings = {
              background = true;
              background_color = "surface";
              background_opacity = 0.88;
              background_padding = 32;
              background_radius = 32;
              opacity = 0.41;
              shadow = true;
              title = "";
            };
          };
          "lockscreen-widget-0000000000000006" = {
            box_height = 96.0;
            box_width = 176.0;
            cx = 571.0;
            cy = 298.5;
            output = "eDP-1";
            placement_height = 768.0;
            placement_width = 1366.0;
            rotation = 0.0;
            type = "volume";
            settings = {
              background_color = "outline";
            };
          };
          "lockscreen-widget-0000000000000008" = {
            box_height = 112.0;
            box_width = 128.0;
            cx = 1291.0;
            cy = 72.0;
            output = "eDP-1";
            placement_height = 768.0;
            placement_width = 1366.0;
            rotation = 0.0;
            type = "sticker";
            settings = {
              background = false;
              image_path = "${config.home.homeDirectory}/Pictures/fc6ed898-5da2-4459-b0f8-87d04e45b5da-removebg-preview.png";
              opacity = 1.0;
            };
          };
          "lockscreen-widget-0000000000000009" = {
            box_height = 304.0;
            box_width = 432.0;
            cx = 658.46875;
            cy = 239.95013427734375;
            flip_y = true;
            output = "eDP-1";
            placement_height = 768.0;
            placement_width = 1366.0;
            rotation = -0.11674448847770691;
            type = "label";
            settings = {
              background_color = "on_primary";
              background_opacity = 1.0;
              background_radius = 32;
              title = "";
            };
          };
        };
      };
      notification = {
        background_opacity = 1.0;
        layer = "overlay";
        offset_x = 17;
        scale = 0.75;
      };
      plugin_settings = {
        "ashur-d/wallpaper-widget" = {
          close_on_apply = true;
          hub_layer = "overlay";
          hub_position = "bottom_center";
        };
        "noctalia/wallhaven" = {
          browser_open_near_click = true;
          download_dir = "${config.home.homeDirectory}/nixos-config/assets/wallpapers";
        };
        "notoxus/media-island" = {
          auto_show = false;
          preview_seconds = 1;
        };
      };
      plugins = {
        enabled = [
          "noctalia/wallhaven"
          "dotnetrob/cat"
          "ashur-d/wallpaper-widget"
          "notoxus/media-island"
          "aristides/udiskie"
          "alexmnrs/github-activity"
          "theblackdon/theme-switcher",
        ];
        source = [
          {
            kind = "git";
            location = "https://github.com/noctalia-dev/official-plugins";
            name = "official";
          }
          {
            kind = "git";
            location = "https://github.com/noctalia-dev/community-plugins";
            name = "community";
          }
        ];
      };
      shell = {
        app_icon_colorize = false;
        avatar_path = "${config.home.homeDirectory}/nixos-config/assets/Pics/anime(cat,girl).jpg";
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
        time_format = "{:%I:%M %p}";
        launcher = {
          width = 560;
        };
        panel = {
          borders = false;
          clipboard_placement = "attached";
          launcher_placement = "attached";
          polkit_placement = "attached";
          transparency_mode = "glass";
        };
        screen_corners = {
          size = 100;
        };
        screenshot = {
          confirm_region = true;
        };
      };
      theme = {
        builtin = "Tokyo-Night";
        community_palette = "Kanagawa Dragon";
        mode = "dark";
        source = "wallpaper";
        wallpaper_scheme = "m3-content";
        templates = {
          builtin_ids = [ "alacritty" "btop" "gtk3" "gtk4" "ghostty" "kitty" "qt" "starship" ];
          community_ids = [
            "opencode"
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
          user = {
            firefox = {
              input_path = "${config.home.homeDirectory}/nixos-config/assets/templates/firefox-colors.css";
              output_path = "${config.home.homeDirectory}/.config/mozilla/firefox/sh4dow/chrome/Colors.css";
            };
            limusic = {
              input_path = "${config.home.homeDirectory}/nixos-config/assets/templates/limusic.css";
              output_path = "${config.home.homeDirectory}/.config/limusic/matugen.css";
            };
            strata = {
              input_path = "${config.home.homeDirectory}/nixos-config/assets/templates/strata-theme.toml";
              output_path = "${config.home.homeDirectory}/.config/strata/themes/noctalia.toml";
            };
            "nvim-base16" = {
              input_path = "${config.home.homeDirectory}/.config/nvim/lua/matugen-template.lua";
              output_path = "${config.home.homeDirectory}/.config/nvim/lua/matugen.lua";
              post_hook = "pkill -SIGUSR1 nvim";
            };
          };
        };
      };
      wallpaper = {
        directory = "${config.home.homeDirectory}/nixos-config/assets/wallpapers";
        transition_on_startup = true;
        automation = {
          enabled = false;
          interval_seconds = 300;
        };
        default = {
          path = "${config.home.homeDirectory}/nixos-config/assets/wallpapers/wallhaven-wqw1wx.jpg";
        };
        last = {
          path = "${config.home.homeDirectory}/nixos-config/assets/wallpapers/wallhaven-wqw1wx.jpg";
        };
        monitors = {
          "eDP-1" = {
            path = "${config.home.homeDirectory}/nixos-config/assets/wallpapers/wallhaven-wqw1wx.jpg";
          };
        };
      };
      weather = {
        enabled = false;
      };
      widget = {
        activity = {
          type = "alexmnrs/github-activity:activity";
        };
        cat = {
          type = "dotnetrob/cat:cat";
        };
        cat_2 = {
          type = "dotnetrob/cat:cat";
        };
        clock = {
          format = "{:%I:%M %p}";
        };
        cpu = {
          type = "sysmon";
          stat = "cpu_usage";
        };
        media = {
          album_art_only = true;
          hide_when_no_media = true;
          rotate_album_art = true;
        };
        network = {
          show_label = false;
        };
        wallhaven = {
          type = "noctalia/wallhaven:wallhaven";
        };
        workspaces = {
          hide_when_empty = true;
          scale = 0.9;
        };
      };
    };
  };
}
