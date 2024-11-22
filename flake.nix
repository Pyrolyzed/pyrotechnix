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

  outputs = { self, nixpkgs, ... }@inputs: {
    # Desktop configuration
    nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./profiles/desktop/configuration.nix
	inputs.home-manager.nixosModules.default
      ];
    };

    # Laptop configuration
    nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./profiles/laptop/configuration.nix
	inputs.home-manager.nixosModules.default
      ];
    };

    # Server configuration
    nixosConfigurations.server = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./profiles/server/configuration.nix
	./profiles/server/hardware-configuration.nix
	inputs.disko.nixosModules.default

	# Not sure if necessary for a server configuration
	inputs.home-manager.nixosModules.default
      ];
    };
  };
}
