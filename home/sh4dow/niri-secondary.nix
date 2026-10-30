{config,pkgs,inputs,...}:{
  imports =[
  ./common.nix
  ../sh4dow/desktop/niri.nix
  ../sh4dow/desktop/matugen.nix
  ./terminal/terminals.nix
  ./applications/strata-matugen.nix
  ];

  sh4dow.themeBackend = "matugen";

  home.packages = with pkgs;[
      quickshell
      awww
      matugen
      slurp
      grim
      zenity
      sddm-astronaut
      bluez
      bluez-tools
  ];
}
