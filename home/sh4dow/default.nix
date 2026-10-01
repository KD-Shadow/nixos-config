{config,pkgs,inputs,...}:{
  imports =[
  ./git.nix
  ./shell.nix
  ];
  home.username="sh4dow";
  home.homeDirectory="/home/sh4dow";
  home.stateVersion = "25.05";


  home.packages = with pkgs;[ripgrep fd fzf btop];

  programs.home-manager.enable=true;
}
