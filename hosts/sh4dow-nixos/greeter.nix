{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.noctalia-greeter.nixosModules.default
  ];

  services.displayManager.noctalia-greeter = {
    enable = true;

    settings = {
      cursor = {
        theme = "Capitaine Cursors";
        size = 24;
        path = "${pkgs.capitaine-cursors}/share/icons";
      };
    };
  };
}
