{ config, ... }:
{
  xdg.configFile."tmux".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nixos-config/dotfiles/tmux";
}
