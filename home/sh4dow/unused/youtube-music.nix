{ config, pkgs, ... }:

{
  home.file.".local/bin/ytm-noads" = {
    executable = true;
    text = ''
      #!${pkgs.bash}/bin/bash

      exec helium \
        --user-data-dir="$HOME/.config/helium-youtube-music" \
        --app="https://music.youtube.com"
    '';
  };

  xdg.desktopEntries.youtube-music = {
    name = "YouTube Music";
    comment = "YouTube Music in Helium";
    exec = "${config.home.homeDirectory}/.local/bin/ytm-noads";
    icon = "audio-x-generic";
    terminal = false;
    categories = [
      "AudioVideo"
      "Audio"
      "Music"
    ];
    startupNotify = true;
  };
}
