{
  description= " My NixOs Configuration";

  inputs={
    nixpkgs.url="github:nixos/nixpkgs/nixos-unstable";

    home-manager={
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };


  outputs = {self, nixpkgs, home-manager, ...}@inputs:{
    nixosConfigurations.sh4dow-nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };

      modules = [
      ./hosts/sh4dow-nixos/configuration.nix
      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.sh4dow = import ./home/sh4dow;
          backupFileExtension = "backup";
        };
      }

      ];
    };
  };
}
