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
  programs.kitty = {
    enable = true;

    font = {
      name = "JetBrainsMono Nerd Font Mono";
      size = 9;
    };

    settings = {
      cursor_shape = "block";
      sync_to_monitor = "yes";
      repaint_delay = 8;
      input_delay = 0;
      cursor_blink_interval = "0.5";
      cursor_stop_blinking_after = 15;
      scrollback_lines = 2000;
      copy_on_select = "yes";
      mouse_hide_wait = 0;
      select_by_word_characters = "@-./_~?&=%+#a";
      enable_audio_bell = "no";
      bell_on_tab = "🔔 ";
      remember_window_size = "no";
      window_border_width = "1pt";
      draw_minimal_borders = "yes";
      window_padding_width = 15;
      inactive_text_alpha = 0.6;
      hide_window_decorations = "yes";
      confirm_os_window_close = 0;
      tab_bar_style = "powerline";
    };

    extraConfig = ''
      include themes/noctalia.conf
    '';
  };
}
