{ config, pkgs, ... }:

{
  xdg.configFile."mango".source =
    ../../dotfiles/mango;
}
