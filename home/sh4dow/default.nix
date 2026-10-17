{config,pkgs,inputs,...}:{
  imports =[
  ./development/git.nix
  ./terminal/shell.nix
  ./development/ssh.nix
  ./desktop/noctalia.nix
  ./desktop/mango.nix
  ./terminal/terminals.nix
  ./desktop/fonts.nix
  ./development/tmux.nix
  ./development/nvim.nix
  ./desktop/gtk.nix
  ./system/utils.nix
  ./applications/zed.nix
  ./applications/youtube-music.nix
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
      uv
      herdr
      glib
      btop
      neovim
      bat
      nodejs
      power-profiles-daemon
      lua
      luaPackages.tree-sitter-cli
      luarocks
      gcc
      mdfried
      rustup
      python3
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
      nautilus
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
      kitty
      inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.zennotes.packages.${pkgs.stdenv.hostPlatform.system}.zennotes-desktop
      inputs.opentubex.packages.${pkgs.stdenv.hostPlatform.system}.opentubex
      inputs.limusic.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  programs.home-manager.enable=true;

#mime types
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "helium.desktop";
      "x-scheme-handler/http" = "helium.desktop";
      "x-scheme-handler/https" = "helium.desktop";

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
      "inode/directory" = "nautilus.desktop";

      # Video
      "video/mp4" = "mpv.desktop";
      "video/webm" = "mpv.desktop";

      # Audio
      "audio/mpeg" = "mpv.desktop";
      "audio/ogg" = "mpv.desktop";
    };
  };
}
