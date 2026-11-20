{ inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../common.nix
    ../greeter.nix
    inputs.mangowm.nixosModules.mango
  ];

  programs.mango.enable = true;
  networking.hostName = "sh4dow-nixos";
  system.stateVersion = "26.05";
}
