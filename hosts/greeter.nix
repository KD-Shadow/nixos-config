{ pkgs, inputs, ... }:

{
  imports = [
    inputs.noctalia-greeter.nixosModules.default
  ];

  services.displayManager.noctalia-greeter = {
    enable = true;

    settings = {
      cursor = {
        theme = "capitaine-cursors";
        size = 24;
        path = "${pkgs.capitaine-cursors}/share/icons";
      };
    };
  };
}
