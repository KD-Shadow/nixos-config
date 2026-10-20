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
          version = "1.3.0";

          src = pkgs.fetchurl {
            url = "https://github.com/SimoHypers/limusic/releases/download/v${version}/${pname}_${version}_amd64.AppImage";
            sha256 = "sha256:b24856ece79330dd3a63f5af2394e6f838dae74aedc61e3677443de90c2b7387";
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

