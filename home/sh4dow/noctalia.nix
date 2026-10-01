{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia = {
    enable = true;

    settings = {
      accessibility = {
        ui_scale = 0.95;
      };

      bar = {
        order = [
          "Sh4dow"
          "default"
        ];

        Sh4dow = {
          border = "on_primary";
          enabled = false;
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
          margin_ends = 99;
          position = "bottom";
          radius = 80;
          radius_top_left = 80;
          radius_top_right = 80;
          scale = 0.75;
          start = [
            "workspaces"
          ];
          widget_spacing = 11;
        };

        default = {
          center = [
            "clock"
            "widget"
          ];
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
          margin_ends = 92;
          position = "right";
          radius_bottom_left = 80;
          radius_bottom_right = 0;
          radius_top_left = 80;
          radius_top_right = 0;
          scale = 0.75;
          start = [
            "workspaces"
            "audio_visualizer"
            "cat"
          ];
          thickness = 34;
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

      desktop_widgets = {
        enabled = true;
        schema_version = 2;

        widget_order = [
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
            box_height = 320.0;
            box_width = 304.0;
            cx = 171.0;
            cy = 592.0;
            output = "eDP-1";
            placement_height = 768.0;
            placement_width = 1366.0;
            rotation = 0.0;
            type = "fancy_audio_visualizer";

            settings = {
              background = false;
              background_opacity = 0.35;
              bloom_intensity = 0.6;
              visualization_mode = "bars_rings";
            };
          };

          "desktop-widget-0000000000000003" = {
            box_height = 96.0;
            box_width = 320.0;
            cx = 187.0;
            cy = 80.0;
            output = "eDP-1";
            placement_height = 768.0;
            placement_width = 1366.0;
            rotation = 0.0;
            type = "clock";

            settings = {
              background = false;
              font_family = "";
              format = "{:%I:%M %p}";
              hide_when_no_media = true;
              layout = "horizontal";
            };
          };
        };
      };

      dock = {
        auto_hide = true;
        reserve_space = false;
        show_running = false;
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

      lockscreen_widgets = {
        enabled = true;
        schema_version = 2;

        widget_order = [
          "lockscreen-login-box@WL-1"
          "lockscreen-login-box@eDP-1"
          "lockscreen-widget-0000000000000001"
          "lockscreen-widget-0000000000000002"
          "lockscreen-widget-0000000000000006"
          "lockscreen-widget-0000000000000007"
        ];

        grid = {
          cell_size = 8;
          major_interval = 4;
          visible = true;
        };

        widget = {
          "lockscreen-login-box@WL-1" = {
            box_height = 196.0;
            box_width = 720.0;
            cx = 640.0;
            cy = 601.0;
            output = "WL-1";
            placement_height = 0.0;
            placement_width = 0.0;
            rotation = 0.0;
            type = "login_box";

            settings = {
              background_color = "surface_variant";
              background_opacity = 0.88;
              background_radius = 12.0;
              center_password_text = false;
              input_opacity = 1.0;
              input_radius = 6.0;
              layout = "regular";
              show_caps_lock = true;
              show_keyboard_layout = true;
              show_login_button = true;
              show_media = true;
              show_session_buttons = true;
              show_unlock_hint = true;
              show_weather = true;
            };
          };

          "lockscreen-login-box@eDP-1" = {
            box_height = 196.0;
            box_width = 720.0;
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
              show_keyboard_layout = false;
              show_login_button = true;
              show_media = true;
              show_session_buttons = true;
              show_unlock_hint = false;
              show_weather = false;
            };
          };

          "lockscreen-widget-0000000000000001" = {
            box_height = 144.0;
            box_width = 328.0;
            cx = 696.5;
            cy = 88.0;
            output = "eDP-1";
            placement_height = 768.0;
            placement_width = 1366.0;
            rotation = 0.0;
            type = "clock";

            settings = {
              background = false;
              background_color = "surface";
              background_opacity = 0.8;
              background_padding = 10;
              background_radius = 12;
              center_text = false;
              circle = true;
              clock_style = "digital";
              color = "primary";
              font_family = "";
              format = "{:%I:%M %p}";
              shadow = true;
            };
          };

          "lockscreen-widget-0000000000000002" = {
            box_height = 0.0;
            box_width = 0.0;
            cx = 675.0;
            cy = 390.5;
            output = "eDP-1";
            placement_height = 768.0;
            placement_width = 1366.0;
            rotation = 0.0;
            type = "fancy_audio_visualizer";

            settings = {
              background = false;
            };
          };

          "lockscreen-widget-0000000000000003" = {
            box_height = 0.0;
            box_width = 0.0;
            cx = 657.5;
            cy = 405.0;
            output = "eDP-1";
            placement_height = 768.0;
            placement_width = 1366.0;
            rotation = 0.0;
            type = "media_player";
          };

          "lockscreen-widget-0000000000000004" = {
            box_height = 0.0;
            box_width = 0.0;
            cx = 74.117645263671875;
            cy = 115.0;
            output = "eDP-1";
            placement_height = 768.0;
            placement_width = 1366.0;
            rotation = 0.0;
            type = "sticker";

            settings = {
              image_path = "/home/sh4dow/Pictures/Pics/boy.jpg";
              opacity = 1.0;
            };
          };

          "lockscreen-widget-0000000000000005" = {
            box_height = 0.0;
            box_width = 0.0;
            cx = 1291.0;
            cy = 115.0;
            output = "eDP-1";
            placement_height = 768.0;
            placement_width = 1366.0;
            rotation = 0.0;
            type = "sticker";

            settings = {
              image_path = "/home/sh4dow/Pictures/Pics/kiritoAsuna.jpg";
              opacity = 1.0;
            };
          };

          "lockscreen-widget-0000000000000006" = {
            box_height = 184.0;
            box_width = 512.0;
            cx = 276.5;
            cy = 384.0;
            output = "eDP-1";
            placement_height = 768.0;
            placement_width = 1366.0;
            rotation = 0.0;
            type = "audio_visualizer";

            settings = {
              background = false;
              bands = 60;
              show_when_idle = false;
            };
          };

          "lockscreen-widget-0000000000000007" = {
            box_height = 192.0;
            box_width = 512.0;
            cx = 1091.0;
            cy = 384.0;
            output = "eDP-1";
            placement_height = 768.0;
            placement_width = 1366.0;
            rotation = 0.0;
            type = "audio_visualizer";

            settings = {
              background = false;
              bands = 60;
              show_when_idle = false;
            };
          };
        };
      };

      notification = {
        background_opacity = 0.7;
        layer = "overlay";
        offset_x = 17;
        scale = 0.75;
      };

      plugin_settings = {
        "blackbartblues/keymap" = {
          compositor = "mangowc";
          mangowc_config = "/home/sh4dow/.config/mango/mango-config/bind.conf";
        };

        "noctalia/mpvpaper" = {
          video_directory = "~/Videos";
        };

        "noctalia/wallhaven" = {
          browser_open_near_click = true;
          download_dir = "/home/sh4dow/Pictures/wallpapers";
        };

        "yngwe/wallpaperCarousel" = {
          carouselMode = "infinite";
          itemHeight = 297;
          itemWidth = 225;
        };

        "yuuto/arch-updater" = {
          aur_helper = "yay";
          terminal = "ghostty";
        };
      };

      plugins = {
        enabled = [
          "noctalia/wallhaven"
          "dotnetrob/cat"
          "yuuto/arch-updater"
          "theblackdon/theme-switcher"
          "ashur-d/nvim-projects"
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

          {
            enabled = false;
            kind = "git";
            location = "https://github.com/noctalia-dev/community-plugins.git";
            name = "community-plugins";
          }
        ];
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

        screen_corners = {
          size = 100;
        };
      };

      templates = {
        "nvim-base16" = {
          input_path = "~/.config/nvim/lua/matugen-template.lua";
          output_path = "~/.config/nvim/lua/matugen.lua";
          post_hook = "pkill -SIGUSR1 nvim";
        };
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
            "mango"
            "qt"
            "starship"
          ];

          community_ids = [
            "zen-browser"
            "libreoffice"
            "obsidian"
            "zed"
            "fastfetch"
            "zathura"
            "bat"
            "herdr"
            "lazygit"
          ];

          enable_builtin_templates = true;
          enable_community_templates = true;

          litexl = {
            input_path = "/home/sh4dow/.config/noctalia/templates/lite-xl.lua";
            output_path = "~/.config/lite-xl/colors/matugen.lua";
          };

          rmpc = {
            input_path = "/home/sh4dow/.config/noctalia/templates/rmpc.ron";
            output_path = "~/.config/rmpc/themes/matugen.ron";
          };

          rofi = {
            input_path = "/home/sh4dow/.config/noctalia/templates/rofi-colors.rasi";
            output_path = "/home/sh4dow/.config/rofi/colors.rasi";
          };
        };
      };

      wallpaper = {
        directory = "/home/sh4dow/Pictures/wallpapers";
        transition_on_startup = true;

        automation = {
          enabled = false;
          interval_seconds = 300;
        };

        default = {
          path = "/home/sh4dow/Pictures/wallpapers/wallhaven-ex.png";
        };

        last = {
          path = "/home/sh4dow/Pictures/wallpapers/wallhaven-ex.png";
        };

        monitors = {
          "eDP-1" = {
            path = "/home/sh4dow/Pictures/wallpapers/wallhaven-ex.png";
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

        clock = {
          format = "{:%I:%M %p}";
        };

        mpvpaper = {
          type = "noctalia/mpvpaper:mpvpaper";
        };

        network = {
          show_label = false;
        };

        wallhaven = {
          type = "noctalia/wallhaven:wallhaven";
        };

        widget = {
          type = "yuuto/arch-updater:widget";
        };

        workspaces = {
          hide_when_empty = true;
          scale = 0.9;
        };
      };
    };
  };
}
