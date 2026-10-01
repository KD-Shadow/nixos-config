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
  };

  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    git
    curl
    wget
  ];

  system.stateVersion = "26.05";
}
