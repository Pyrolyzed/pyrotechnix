{
  description = "Pyrolyzed's Pyrotechnix Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf.url = "github:notashelf/nvf";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
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
        user = "pyro";
        modules = [ ];
      };
      commonArgs = createCommonArgs system;
    in
    {
      packages."x86_64-linux".default =
      	(inputs.nvf.lib.neovimConfiguration {
	  pkgs = nixpkgs.legacyPackages."x86_64-linux";
	  modules = [ ./default/nvf-configuration.nix ];
	}).neovim;
      nixosConfigurations = (import ./hosts/nixos.nix commonArgs);
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
      inherit lib self;
    };
}
