{ inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../common.nix
    ../greeter.nix
    inputs.umbriel.nixosModules.default
  ];

  programs.umbriel.enable = true;

  networking.hostName = "sh4dow-umbriel";
  system.stateVersion = "26.11";
}
