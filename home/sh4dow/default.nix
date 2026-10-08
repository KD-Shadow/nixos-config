{config,pkgs,inputs,...}:{
  imports =[
  ./development/git.nix
  ./terminal/shell.nix
  ./development/ssh.nix
  ./desktop/noctalia.nix
  ./desktop/mango.nix
  ./terminal/terminals.nix
  ./desktop/fonts.nix
  ./development/nvim.nix
  ./desktop/gtk.nix
  ./system/utils.nix
  ./applications/zed.nix
  ./applications/youtube-music.nix
  ];

  home.username="sh4dow";
  home.homeDirectory="/home/sh4dow";
  home.stateVersion = "25.05";


  home.packages = with pkgs;[
      ripgrep 
      tree
      fd 
      fzf 
      glib
      btop
      neovim
      bat
      nodejs
      lua
      luaPackages.tree-sitter-cli
      luarocks
      gcc
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
      pcmanfm
      fastfetch
      brightnessctl
      mpd
      gtk3
      gtk4
      adw-gtk3
      capitaine-cursors
      kora-icon-theme
      nwg-look
      neovide
      superfile
      eog
      github-cli
      zed-editor
      rmpc 
      cliphist
      wl-clipboard
      wl-clip-persist
      obsidian
      bun
      zathura
      ghgrab
      zathuraPkgs.zathura_pdf_mupdf
      libreoffice-stable
      localsend
      inputs.helium.packages.${pkgs.system}.default
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
      "image/jpeg" = "eog.desktop";
      "image/webp" = "eog.desktop";

      # Text / code
      "text/plain" = "nvim.desktop";

      # File manager
      "inode/directory" = "pcmanfm.desktop";

      # Video
      "video/mp4" = "mpv.desktop";
      "video/webm" = "mpv.desktop";

      # Audio
      "audio/mpeg" = "mpv.desktop";
      "audio/ogg" = "mpv.desktop";
    };
  };
}
