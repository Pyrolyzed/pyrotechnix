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
    in {
      nixosConfigurations = {
	# Desktop configuration
	desktop = nixpkgs.lib.nixosSystem {
	  inherit pkgs;
	  specialArgs = { inherit inputs; };
	  modules = [
	    ./profiles/desktop/configuration.nix
	    inputs.home-manager.nixosModules.default
	  ];
	};

	# Laptop configuration
	laptop = nixpkgs.lib.nixosSystem {
	  inherit pkgs;
	  specialArgs = { inherit inputs; };
	  modules = [
	    ./profiles/laptop/configuration.nix
	    inputs.home-manager.nixosModules.default
	  ];
	};

	# Server configuration
	homeserver-1 = nixpkgs.lib.nixosSystem {
	  inherit pkgs;
	  specialArgs = { inherit inputs; };
	  modules = [
	    ./profiles/homeserver-1/configuration.nix
	    ./profiles/homeserver-1/hardware-configuration.nix
	    inputs.disko.nixosModules.default

	    # Not sure if necessary for a server configuration
	    inputs.home-manager.nixosModules.default
	  ];
	};

	# ISO Installer
	isoInstaller = nixpkgs.lib.nixosSystem {
	  inherit pkgs;
	  specialArgs = { inherit inputs; };
	  modules = [
	    ./profiles/iso/configuration.nix
	  ];
	};
      };
      inherit lib self;
    };
}
