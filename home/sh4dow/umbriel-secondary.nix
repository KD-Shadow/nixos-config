{...}:{
  imports =[
  ./common.nix
  ./desktop/noctalia.nix
  ./terminal/terminals.nix
  ./applications/umbriel.nix
  ./applications/strata.nix
  ];

  sh4dow.themeBackend = "noctalia";

}
