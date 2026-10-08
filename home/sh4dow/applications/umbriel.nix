{ ... }:

{
  programs.umbriel= {
      enable = true;
      settings = {
        general = {
          autostart = [
            "noctalia"
          ];
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
          "Mod+Return" = "spawn:alacritty";
          "Mod+Q" = "window-close";
          "Mod+Left" = "window-focus-left";
          "Mod+Right" = "window-focus-right";
          "Mod+I" = "overview-toggle";

          "Mod+Comma" = "spawn:noctalia msg settings-toggle";
          "Mod+Space" = "spawn:noctalia msg panel-toggle launcher";
          "Mod+V" = "spawn:noctalia msg panel-toggle clipboard";
          "Mod+W" = "spawn:noctalia msg panel-toggle wallpaper";
          "Mod+P" = "spawn:noctalia msg screenshot-region";
          "Mod+Escape" = "spawn:noctalia msg panel-toggle session";
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
