{inputs, config, pkgs,  ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./greeter.nix
  ];

# plymouth setup
    boot = {
    plymouth = {
      enable = true;
      theme = "hud_3";
      themePackages = with pkgs; [
        # By default we would install all themes
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "unrap" "circle_hud" "deus_ex" "hud_3"];
        })
      ];
    };

    # Enable "Silent boot"
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "rd.udev.log_level=3"
      "rd.systemd.show_status=auto"
    ];

    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    loader.timeout = 0;
  };
#  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernelPackages = pkgs.linuxPackages_cachyos;

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
      "docker"
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
  virtualisation.docker.enable = true;
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
