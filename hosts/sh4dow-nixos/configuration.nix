{... }:

{
  imports = [
    ./hardware-configuration.nix
    ../common.nix
    ../greeter.nix
  ];
  networking.hostName = "sh4dow-nixos";
  sh4dow.themeBackend = "noctalia";
  system.stateVersion = "26.05";
}
