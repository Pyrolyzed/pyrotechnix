{
  description = "Pyrolyzed's Pyrotechnix Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    impermanence.url = "github:nix-community/impermanence";
    nvf.url = "github:notashelf/nvf";

    # TODO: Phase out Disko.
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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

      pkgs-stable = import inputs.nixpkgs-stable {
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
          pkgs-stable
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
      packages.${system}.default =
        (inputs.nvf.lib.neovimConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            (import ./default/nvf-configuration.nix {
              inherit pkgs;
              inherit lib;
              dots = "/persist/home/pyro/Projects/pyrotechnix";
            })
          ];
        }).neovim;
      nixosConfigurations = (import ./hosts/nixos.nix commonArgs);
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
      inherit lib self;
    };
}
