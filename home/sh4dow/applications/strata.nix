{ config, lib, pkgs, inputs, ... }:

let
  strata = inputs.strata.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  home.file.".local/bin/strata" = {
    source = "${strata}/bin/strata";
    executable = true;
  };
  xdg.configFile."strata/settings.toml".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nixos-config/dotfiles/strata/settings.toml";

  home.activation.strataThemesDir = lib.mkBefore ''
    mkdir -p "$HOME/.config/strata/themes"
  '';
}
