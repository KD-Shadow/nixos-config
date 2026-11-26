{ config, lib, ... }:

{
  # The strata binary itself comes from inputs.strata via home.packages in
  # common.nix (official github:lgse/strata flake). This file only keeps the
  # user config and the theme directory used by the Noctalia strata template.
  xdg.configFile."strata/settings.toml".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nixos-config/dotfiles/strata/settings.toml";

  home.activation.strataThemesDir = lib.mkBefore ''
    mkdir -p "$HOME/.config/strata/themes"
  '';
}
