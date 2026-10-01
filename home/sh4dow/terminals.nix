{ config, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;

    settings = {
      general = {
        import = [
          "~/.config/alacritty/themes/noctalia.toml"
        ];
        live_config_reload = true;
      };

      env = {
        TERM = "alacritty";
        WINIT_X11_SCALE_FACTOR = "1.0";
      };

      cursor = {
        blink_interval = 550;
        unfocused_hollow = false;
        thickness = 0.15;

        style = {
          blinking = "On";
          shape = "Block";
        };
      };

      selection = {
        save_to_clipboard = true;
      };

      window = {
        decorations = "none";
        dynamic_title = true;
        opacity = 1.0;

        padding = {
          x = 15;
          y = 15;
        };

        dynamic_padding = true;
        resize_increments = true;
      };

      scrolling = {
        history = 10000;
        multiplier = 3;
      };

      bell = {
        animation = "Linear";
        duration = 0;

        command = {
          program = "paplay";
          args = [
            "/usr/share/sounds/freedesktop/stereo/dialog-error.oga"
          ];
        };
      };

      font = {
        size = 9;
        builtin_box_drawing = true;

        normal = {
          family = "JetBrainsMono Nerd Font";
        };
      };
    };
  };

  programs.ghostty = {
    enable = true;

    settings = {
      font-family = "JetBrainsMono Nerd Font Mono";
      font-size = 11.5;

      window-padding-x = 15;
      window-padding-y = 15;

      window-decoration = false;

      cursor-style = "block";
      cursor-style-blink = true;

      quit-after-last-window-closed = true;
      confirm-close-surface = false;

      scrollbar = "never";

      theme = "noctalia";
    };
  };
}
