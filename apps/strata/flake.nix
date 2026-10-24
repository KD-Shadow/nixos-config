{
  description = "Strata file manager on NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        strataTarball = pkgs.fetchurl {
          url = "https://github.com/lgse/strata/releases/download/v1.1.0/strata-1.1.0-x86_64-unknown-linux-gnu.tar.gz";
          hash = "sha256-yyknz7+F6v7x+qUxYwPfnOUYMcejcCBPigaL2DxpB5M=";
        };

        strataSrc = pkgs.stdenv.mkDerivation {
          pname = "strata-src";
          version = "1.1.0";

          src = strataTarball;

          unpackPhase = ''
            tar -xzf $src
          '';

          installPhase = ''
            mkdir -p $out
            cp -r strata-1.1.0-x86_64-unknown-linux-gnu/* $out/
          '';
        };

        fhs = pkgs.buildFHSEnv {
          name = "strata-fhs";
          targetPkgs = pkgs: with pkgs; [
            bubblewrap gtk4 pango gdk-pixbuf cairo graphene glib poppler
            gtksourceview5 fontconfig stdenv.cc.cc.lib
            gst_all_1.gstreamer gst_all_1.gst-plugins-base gst_all_1.gst-plugins-good
            glib-networking gvfs xdg-utils
          ];
          runScript = "bash";
        };
      in
      {
        packages = rec {
          strata = pkgs.stdenv.mkDerivation {
            pname = "strata";
            version = "1.1.0";
            dontUnpack = true;
            installPhase = ''
              mkdir -p $out/bin $out/share/applications $out/share/icons/hicolor/scalable/apps
              cat > $out/bin/strata << SCRIPT
#!/usr/bin/env bash
export XDG_DATA_DIRS=${strataSrc}/share:\''${XDG_DATA_DIRS:-/run/current-system/sw/share}
exec ${fhs}/bin/strata-fhs -c "cd /home/sh4dow && ${strataSrc}/strata \"\$@\"" _ "\$@"
SCRIPT
              chmod +x $out/bin/strata
              install -Dm644 ${strataSrc}/io.github.lgse.Strata.desktop $out/share/applications/io.github.lgse.Strata.desktop
              ${pkgs.gnused}/bin/sed -i "s|Exec=strata |Exec=$out/bin/strata |g" $out/share/applications/io.github.lgse.Strata.desktop
              install -Dm644 ${strataSrc}/io.github.lgse.Strata.svg $out/share/icons/hicolor/scalable/apps/io.github.lgse.Strata.svg
              install -Dm644 ${strataSrc}/portal/strata.portal $out/share/xdg-desktop-portal/portals/strata.portal
              mkdir -p $out/share/dbus-1/services
              ${pkgs.gnused}/bin/sed "s|@STRATA_EXECUTABLE@|$out/bin/strata|" \
                ${strataSrc}/portal/org.freedesktop.impl.portal.desktop.strata.service.in \
                > $out/share/dbus-1/services/org.freedesktop.impl.portal.desktop.strata.service
              ${pkgs.gnused}/bin/sed "s|/usr/bin/strata |$out/bin/strata |" \
                ${strataSrc}/io.github.lgse.Strata.FileManager1.service \
                > $out/share/dbus-1/services/org.freedesktop.FileManager1.service
            '';
          };
          default = strata;
        };
      }
    );
}
