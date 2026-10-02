{ config, pkgs, inputs, ... }:

{
  gtk = {
    enable = true;

    theme = {
      name = "adw-gtk3-dark";
    };

    gtk4 = {
      theme = {
        name = "adw-gtk3-dark";
      };
    };

    iconTheme = {
      name = "kora";
    };

    cursorTheme = {
      name = "capitaine cursors";
      size = 24;
    };

    font = {
      name = "JetBrainsMono Nerd Font Mono";
      size = 10;
    };
  };

  dconf.settings = {
      "org/gnome/desktop/interface" = {
        text-scaling-factor = 0.75;
      };
  };
}
