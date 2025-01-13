# This file shamelessly copied from the one and only iynaix.
{ inputs, lib, specialArgs, modules, user ? "pyro", ...}@args:
let
  mkConfiguration =
    host: { pkgs ? args.pkgs, }:
      lib.nixosSystem {
        inherit pkgs;

	specialArgs = specialArgs // {
	  inherit host user;
	  isNixOS = true;
	  isDesktop = host == "emperor";
	  isLaptop = host == "duke";
	  isVm = host == "vm";
	  isServer = host == "homeserver-1" || host == "homeserver-2" || host == "homeserver-3";
	  dotfiles = "/home/${user}/Projects/dotfiles";
	};

	modules = modules ++ [
	  ./${host} # Host specific configuration
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
		dotfiles = "/home/${user}/Projects/dotfiles";
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
	  # Alias for home-manager.
	  (lib.mkAliasOptionModule [ "hm" ] [
	    "home-manager"
	    "users"
	    user
	  ])
	];
      };
in {
  emperor = mkConfiguration "emperor" { };
  duke = mkConfiguration "duke" { };
  homeserver-1 = mkConfiguration "homeserver-1" { };
}
