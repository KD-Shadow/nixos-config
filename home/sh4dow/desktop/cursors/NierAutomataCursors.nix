{pkgs,...}:{

home.pointerCursor = 
  let
    getFrom = url: hash: name: {
      gtk.enable = true;
      x11.enable = true;
      name = name;
      size = 24;
      package = pkgs.runCommand "moveUp" { } ''
        mkdir -p $out/share/icons
        ln -s ${
          pkgs.fetchzip {
            url = url;
            hash = hash;
          }
        } $out/share/icons/${name}
      '';
    };
  in
  getFrom "https://github.com/Beinsezii/NieR-Cursors/releases/download/2020-08-25/NieR_Cursors_2020-08-25.tar.xz"
    "sha256-a8AwQneJDUHYZm8UEw/Yzeurcf8GEaeZFgL7FTaDSLg="
    "NieR-Cursors";

}
