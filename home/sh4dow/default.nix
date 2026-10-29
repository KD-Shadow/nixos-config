{config,pkgs,inputs,...}:{
  imports =[
  ./common.nix
  ./desktop/noctalia.nix
  ./desktop/mango.nix
  ./terminal/terminals.nix
  ];

  sh4dow.themeBackend = "noctalia";
}
