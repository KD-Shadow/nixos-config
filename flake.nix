{
  description= " My NixOs Configuration";

  nixConfig = {
  extra-substituters = [
   "https://noctalia.cachix.org"
#   "https://attic.xuyh0120.win/lantian"
  ];

  extra-trusted-public-keys = [
    "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
   # "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="

  ];
  };

  inputs={
    nixpkgs.url="github:nixos/nixpkgs/nixos-unstable";

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    home-manager={
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mangowm = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helium = {
      url = "github:AlvaroParker/helium-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
     zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # umbriel.url = "github:noctalia-dev/umbriel";
    
    
  };


  outputs = {self, nixpkgs, home-manager,chaotic, ...}@inputs:{
    nixosConfigurations.sh4dow-nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };

      modules = [
      ./hosts/sh4dow-nixos/configuration.nix
      home-manager.nixosModules.home-manager
      chaotic.nixosModules.default
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = { inherit inputs; };
          users.sh4dow = {
            imports = [
              # inputs.umbriel.homeModules.default
              ./home/sh4dow
            ];
          };

          backupFileExtension = "backup";
        };
      }

      ];
    };
  };
}
