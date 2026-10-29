
{ pkgs, ... }:

let
  sddm-astronaut = pkgs.sddm-astronaut.override {
    embeddedTheme = "black_hole";
  };
in
{
  imports = [
    ./hardware-configuration.nix
    ../common.nix
  ];

  environment.systemPackages = with pkgs; [
    sddm-astronaut
  ];

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;

    theme = "${sddm-astronaut}/share/sddm/themes/sddm-astronaut-theme";

    extraPackages = with pkgs; [
      sddm-astronaut
      kdePackages.qtsvg
      kdePackages.qtvirtualkeyboard
      kdePackages.qtmultimedia
    ];
  };

  hardware.bluetooth.enable = true;
  services.upower.enable = true;

  networking.hostName = "sh4dow-niri";
  system.stateVersion = "26.11";
}
