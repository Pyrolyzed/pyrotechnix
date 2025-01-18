{ inputs, lib, specialArgs, modules, user ? "pyro", ...}@args:
let
  mkConfiguration =
    host: { pkgs ? args.pkgs, }:
      inputs.nixpkgs.lib.nixosSystem {
        inherit pkgs;

	specialArgs = specialArgs // {
	  inherit host user;
	  isNixOS = true;
	  isDesktop = host == "emperor";
	  isLaptop = host == "duke";
	  isVm = host == "vm";
	  isServer = host == "homeserver-1" || host == "homeserver-2" || host == "homeserver-3";
	};

	modules = modules ++ [
	  ./${host}/configuration.nix # Host specific configuration
	  ./${host}/hardware.nix # Host hardware configuration
	  ../nixos # Common nixos configuration
	  ../overlays # Access to overlays
	  inputs.home-manager.nixosModules.home-manager {
	    home-manager = {

	      # Not just special, extra special.
	      extraSpecialArgs = specialArgs // {
		inherit host user;
		isNixOS = true;
		isDesktop = host == "emperor";
		isLaptop = host == "duke";
		isVm = host == "vm";
	        isServer = host == "homeserver-1" || host == "homeserver-2" || host == "homeserver-3";
	      };

	      users.${user} = {
	        imports = [
		  ./${host}/home.nix # Host specific home configuration
		  ../home-manager # Common home configuration
		];
	      };
	    };
	  }
          inputs.disko.nixosModules.default # Disko just in case the host uses it.
	];
      };
  getHomeservers = range: 
    map (n: "homeserver-${n}") range;
  mkHomeservers = range:
    lib.attrsets.genAttrs (getHomeservers range) (name: mkConfiguration name);
in {
  emperor = mkConfiguration "emperor" { };
  duke = mkConfiguration "duke" { };
} // mkHomeservers lib.range (1 3)
