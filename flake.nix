{
  description = "Pyrolyzed's Pyrotechnix Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1&rev=688fe5c14781c63a1db23d4d02bf239283068ff6";
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

	# Not sure if necessary for a server configuration
	inputs.home-manager.nixosModules.default
      ];
    };
  };
}
