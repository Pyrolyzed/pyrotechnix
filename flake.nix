{
  description = "Pyrolyzed's Pyrotechnix Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: 
    let
      system = "x86_64-linux";
      pkgs = import inputs.nixpkgs {
	inherit system;
	config.allowUnfree = true;
	config.permittedInsecurePackages = [
	  "freeimage-unstable-2021-11-01"
	];
      };
      lib = import ./lib/utils.nix {
        inherit (nixpkgs) lib;
	inherit pkgs;
	inherit (inputs) home-manager;
      };
      createCommonArgs = system: {
        inherit
	  self
	  inputs
	  nixpkgs
	  lib
	  pkgs
	  system
	  ;
        specialArgs = {
	  inherit self inputs;
	};
	# user = "test";
	# modules = [ ];
      };
      commonArgs = createCommonArgs system;
    in {
      nixosConfigurations = (import ./hosts/nixos.nix commonArgs);
      inherit lib self;
    };
}
