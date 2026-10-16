
{ config, pkgs, ... }:

{
  home.file.".local/bin/tldraw" = {
    executable = true;
    text = ''
      #!${pkgs.bash}/bin/bash

      exec helium \
        --user-data-dir="$HOME/.config/tldraw-helium" \
        --app="https://tldraw.com"
    '';
  };

  xdg.desktopEntries.tldraw = {
    name = "tldraw ";
    comment = "tldraw in Helium";
    exec = "${config.home.homeDirectory}/.local/bin/tldraw";
    icon = "audio-x-generic";
    terminal = false;
    categories = [
      "Graphics"
    ];
    startupNotify = true;
  };
}
