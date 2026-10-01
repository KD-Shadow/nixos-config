{ config, ... }:
{
  xdg.configFile."mango".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nixos-config/dotfiles/mango";
}
