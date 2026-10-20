{pkgs,...}:{
  home.pointerCursor = {
    enable = true;
    name = "ModestDark";
    package = pkgs.runCommand "modest-dark-cursor" {} ''
      mkdir -p $out/share/icons
      ln -s /home/sh4dow/nixos-config/assets/ModestDarkCursors/ \
        $out/share/icons/ModestDark
    '';
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

}
