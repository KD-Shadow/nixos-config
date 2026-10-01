{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    bitstream-vera
    dejavu_fonts

    jetbrains-mono
    nerd-fonts.jetbrains-mono
    nerd-fonts.meslo-lg

    liberation_ttf
    open-sans

    adwaita-fonts
    awesome-terminal-fonts
    cantarell-fonts

    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];
}
