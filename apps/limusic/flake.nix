{
  description = "Limusic on Nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
        limusic = pkgs.appimageTools.wrapType2 rec {

          pname = "limusic";
          version = "1.2.0";

          src = pkgs.fetchurl {
            url = "https://github.com/SimoHypers/limusic/releases/download/v${version}/${pname}_${version}_amd64.AppImage";
            sha256 = "sha256:ea0b1680216f26e6ce4e7b4cda9ba04286db417618d3ec2e4782b28e65550c98";
          };

            extraInstallCommands =
              let
                contents = pkgs.appimageTools.extract { inherit pname version src; };
              in
              ''
                install -m 444 -D ${contents}/${pname}.desktop \
                  -t $out/share/applications

                substituteInPlace $out/share/applications/${pname}.desktop \
                  --replace 'Exec=limusic-app' "Exec=$out/bin/${pname}"

                cp -r ${contents}/usr/share/icons $out/share
              '';
        };
      in
      {
        packages = {
          inherit limusic;
          default = limusic;
        };
      }
    );
}

