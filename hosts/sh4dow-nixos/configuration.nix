{ inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../common.nix
    ../greeter.nix
    inputs.mangowm.nixosModules.mango
    inputs.umbriel.nixosModules.default
  ];

  programs.mango.enable = true;
  programs.umbriel.enable = true;
  networking.hostName = "sh4dow-nixos";
  system.stateVersion = "26.05";
}
