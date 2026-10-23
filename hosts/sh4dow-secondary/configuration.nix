{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../common.nix
    ../greeter.nix
  ];

  networking.hostName = "sh4dow-secondary";
  system.stateVersion = "26.11";
}
