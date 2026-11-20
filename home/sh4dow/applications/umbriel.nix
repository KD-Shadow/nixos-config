{ inputs,... }:

{
  imports = [inputs.umbriel.homeModules.default];
  programs.umbriel= {
      enable = true;
      settings = {
        general = {
          # Noctalia is started by its systemd user service (see desktop/noctalia.nix).
          mod_key = "Super";
          xwayland = true;
          xwayland_native_resolution = false;
          show_cheatsheet = false;
          focus_on_activate = false;
          honor_restored_maximize = false;
        };

        input.cursor = {
          theme = "capitaine-cursors";
          size = 24;
          hardware_cursor = true;
          follows_focus = false;
          hide_when_typing = false;
          hide_timeout_ms = 0;
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

          # Audio
          "XF86AudioRaiseVolume" = "spawn wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
          "XF86AudioLowerVolume" = "spawn wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          "XF86AudioMute" = "spawn wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          "XF86AudioPlay" = "spawn noctalia msg media toggle";
          "XF86AudioNext" = "spawn noctalia msg media next";
          "XF86AudioPrev" = "spawn noctalia msg media previous";

          # Brightness
          "XF86MonBrightnessUp" = "spawn brightnessctl set +5%";
          "XF86MonBrightnessDown" = "spawn brightnessctl set 5%-";

          # Noctalia shell
          "Mod+Comma" = "spawn noctalia msg settings-toggle";
          "Mod+Space" = "spawn noctalia msg panel-toggle launcher";
          "Mod+V" = "spawn noctalia msg panel-toggle clipboard";
          "Mod+W" = "spawn noctalia msg panel-toggle wallpaper";
          "Mod+P" = "spawn noctalia msg screenshot-region";
          "Mod+Escape" = "spawn noctalia msg panel-toggle session";
          "Mod+L" = "spawn noctalia msg session lock";
          "Mod+Shift+Tab" = "spawn noctalia msg window-switcher";
        };

        appearance = {
          prefer_no_csd = true;
          border_width = 1;
          outer_border_width = 0;
          corner_radius = 6;
          drag_opacity = 0.75;
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
            passes = 3;
            radius = 5;
            noise = 0.02;
            brightness = 0.9;
            contrast = 0.9;
            saturation = 1.1;
          };

          shadow = {
            enabled = true;
            softness = 10;
            offset_x = 2;
            offset_y = 2;
          };
        };
      };
  };
}
