{ config, pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    configPath = "${config.xdg.configHome}/mozilla/firefox";

    profiles.sh4dow = {
      id = 0;
      name = "sh4dow";
      path = "sh4dow";
      isDefault = true;

      extraConfig = builtins.readFile ../../../assets/firefox/user.js;

      userChrome = builtins.readFile ../../../assets/firefox/chrome/userChrome.css;
      userContent = builtins.readFile ../../../assets/firefox/chrome/userContent.css;
    };
  };

  xdg.configFile = {
    "mozilla/firefox/sh4dow/chrome/add.svg".source =
      ../../../assets/firefox/chrome/add.svg;

    "mozilla/firefox/sh4dow/chrome/addd.svg".source =
      ../../../assets/firefox/chrome/addd.svg;
  };
}
