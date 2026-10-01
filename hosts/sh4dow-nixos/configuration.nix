{config,pkgs,inputs,...}:{
  imports = [./hardware-configuration.nix];

  boot.loader = {
    systemd-boot.enable = false;
    efi.canTouchEfiVariables = true;
    limine = {
    enable = true;
    efiSupport = true;
    maxGenerations = 10;
  };
};

  nix.settings.experimental-features=["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;

  networking.hostName = "sh4dow-nixos";

  users.users.sh4dow = {  
    isNormalUser=true;
    extraGroups=["wheel" "networkmanager"];
  };
  
  programs.fish.enable= true;
  environment.systemPackages= with pkgs;[git curl wget];
  system.stateVersion="26.05";
}

