{
  description = "NixOS Configuration flake.";

  outputs = { self, nixpkgs, ...}@inputs: 
    let
      # FLAKE SETTINGS
      profile = "desktop";
    in {
      nixosConfigurations.system = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
	  # Add profile configuration.
          ./profiles/${profile}/configuration.nix

	  # Add in Home Manager.
	  inputs.home-manager.nixosModules.default
        ];
      };
    };

  inputs = {
    # Unstable Nixpkgs.
    nixpkgs.url = "nixpkgs/nixos-unstable";

    # Home Manager.
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

}
