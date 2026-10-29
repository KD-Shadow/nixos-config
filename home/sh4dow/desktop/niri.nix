{ config, ... }:
{
  xdg.configFile."niri".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nixos-config/dotfiles/niri";
}
