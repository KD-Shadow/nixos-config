{config,pkgs,inputs,...}:{
  imports =[
  ./git.nix
  ./shell.nix
  ./ssh.nix
  ./noctalia.nix
  ./mango.nix
  ./terminals.nix
  ./fonts.nix
  ./nvim.nix
  ];

  home.username="sh4dow";
  home.homeDirectory="/home/sh4dow";
  home.stateVersion = "25.05";


  home.packages = with pkgs;[
      ripgrep 
      fd 
      fzf 
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
      zed
      rmpc 
      cliphist
      wl-clipboard
      wl-clip-persist
      xdg-desktop-portal-wlr
      obsidian
      bun
      zathura
      zathuraPkgs.zathura_pdf_mupdf
      libreoffice-fresh
  ];

  programs.home-manager.enable=true;
}
