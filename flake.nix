{
  description= " My NixOs Configuration";

  nixConfig = {
  extra-substituters = [
    "https://noctalia.cachix.org"
  ];

  extra-trusted-public-keys = [
    "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
  ];
  };

  inputs={
    nixpkgs.url="github:nixos/nixpkgs/nixos-unstable";

    home-manager={
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia";
    };
    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
    };
    mangowm = {
      url = "github:mangowm/mango";
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
