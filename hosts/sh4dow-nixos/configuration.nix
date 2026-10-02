{ config, pkgs,  ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./greeter.nix
  ];

  boot.loader = {
    systemd-boot.enable = false;
    efi.canTouchEfiVariables = true;

    limine = {
      enable = true;
      efiSupport = true;
      maxGenerations = 10;

      style = {
        wallpapers = [
          ../../assets/wallpapers/wallhaven-ex.png
        ];
      };
    };
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  networking = {
    hostName = "sh4dow-nixos";
    networkmanager.enable = true;
  };

  time.timeZone = "Asia/Kathmandu";

  # Audio
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };

  # SSH
  services.openssh.enable = true;

  users.users.sh4dow = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    shell=pkgs.fish;
  };
  xdg.portal = {
    enable = true;

    extraPortals = with pkgs;[
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
    config.common.default = "";
  };

  programs.fish.enable = true;
  programs.dconf.enable = true;
  hardware.graphics.enable = true;
  environment.pathsToLink = [ "/share/wayland-sessions" "/share/xsessions" ];

  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    efibootmgr
    xdg-utils
  ];

  system.stateVersion = "26.05";
}
