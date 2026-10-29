{config,pkgs,inputs,...}:{
  imports =[
  ./common.nix
  ../sh4dow/desktop/niri.nix
  ../sh4dow/desktop/matugen.nix
  ];

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
