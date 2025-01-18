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
	  isServer = lib.strings.hasPrefix "homeserver" host;
	};

	modules = modules ++ [
	  if isServer then ./homeserver/${host}/configuration.nix else ./${host}/configuration.nix # Host specific configuration
	  if isServer then ./homeserver/${host}/hardware.nix else ./${host}/hardware.nix # Host hardware configuration
	  if isServer then ./homeserver else { } # Common homeserver configuration
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
	        isServer = lib.strings.hasPrefix "homeserver" host;
	      };

	      users.${user} = {
	        imports = [
		  if isServer then ./homeserver/${host}/home.nix else ./${host}/home.nix # Host specific home configuration
		  ../home-manager # Common home configuration
		];
	      };
	    };
	  }
          inputs.disko.nixosModules.default # Disko just in case the host uses it.
	];
      };
  getHomeservers = range: 
    map (n: "homeserver-${toString n}") range;
  mkHomeservers = range:
    lib.attrsets.genAttrs (getHomeservers range) (name: mkConfiguration name { });
in {
  emperor = mkConfiguration "emperor" { };
  duke = mkConfiguration "duke" { };
} // mkHomeservers (lib.range 1 3)
