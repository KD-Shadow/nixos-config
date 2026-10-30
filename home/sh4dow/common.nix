{config,pkgs,inputs,...}:{
  imports =[
  ./development/git.nix
  ./terminal/shell.nix
  ./development/ssh.nix
  ./desktop/fonts.nix
  ./development/nvim.nix
  ./development/herdr.nix
  ./desktop/gtk.nix
  ./system/utils.nix
  # ./applications/librewolf.nix
  ./applications/firefox.nix
  ./applications/zed.nix
  ./applications/tldraw.nix
  ];

  home.username="sh4dow";
  home.homeDirectory="/home/sh4dow";
  home.stateVersion = "25.05";


  home.packages = with pkgs;[
      ripgrep 
      tree
      fd 
      fzf 
      herdr
      udiskie
      glib
      btop
      neovim
      bat
      rustup
      nodejs
      power-profiles-daemon
      lua
      luaPackages.tree-sitter-cli
      luarocks
      gcc
      mdfried
      tmux
      eza
      zip 
      unzip
      mpv
      lazygit
      libnotify
      zoxide
      ffmpeg
      yt-dlp
      cava
      # pcmanfm
      fastfetch
      brightnessctl
      mpd
      gtk3
      gtk4
      adw-gtk3
      capitaine-cursors
      kora-icon-theme
      neovide
      superfile
      eog
      github-cli
      zed-editor
      file
      cliamp 
      cliphist
      wl-clipboard
      wl-clip-persist
      bun
      zathura
      ghgrab
      bat
      zathuraPkgs.zathura_pdf_mupdf
      libreoffice-stable
      tuxedo
      google-cursor
      yaak
      localsend
      surge-downloader
      jq
      opencode
      kitty
      imagemagick
      bubblewrap
      #inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.limusic.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.strata.packages.${pkgs.stdenv.hostPlatform.system}.default
      #inputs.opentubex.packages.${pkgs.stdenv.hostPlatform.system}.opentubex
  ];
  programs.home-manager.enable=true;
  #session variables
  home.sessionVariables = {
      TERMINAL = "alacritty";
      EDITOR = "nvim";
  };
  #default terminal
  xdg.terminal-exec = {
    enable = true;
    settings = {
      default = [
        "Alacritty.desktop"
      ];
    };
  };

#mime types
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";

      # PDF
      "application/pdf" = "org.pwmt.zathura.desktop";

      # Images
      "image/png" = "org.gnome.eog.desktop";
      "image/jpeg" = "org.gnome.eog.desktop";
      "image/jpg" = "org.gnome.eog.desktop";
      "image/webp" = "org.gnome.eog.desktop";

      # Text / code
      "text/plain" = "nvim.desktop";
      "text/markdown" = "mdfried.desktop";

      # File manager
      "inode/directory" = "io.github.lgse.Strata.desktop";
      "x-scheme-handler/trash" = "io.github.lgse.Strata.desktop";

      # terminal
      "application/x-sh" = "Alacritty.desktop";
      "application/x-shellscript" = "Alacritty.desktop";

      # Video
      "video/mp4" = "mpv.desktop";
      "video/webm" = "mpv.desktop";

      # Audio
      "audio/mpeg" = "mpv.desktop";
      "audio/ogg" = "mpv.desktop";
    };
  };
}
