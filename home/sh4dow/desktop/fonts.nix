{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    ttf-bitstream-vera
    dejavu_fonts

    jetbrains-mono
    nerd-fonts.jetbrains-mono
    nerd-fonts.meslo-lg

    liberation_ttf

    adwaita-fonts
    cantarell-fonts

    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];
}
