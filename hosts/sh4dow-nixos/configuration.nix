{... }:

{
  imports = [
    ./hardware-configuration.nix
    ../common.nix
    ../greeter.nix
  ];
  networking.hostName = "sh4dow-nixos";

  system.stateVersion = "26.05";
}
