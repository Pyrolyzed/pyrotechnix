{
  inputs,
  lib,
  specialArgs,
  modules,
  user ? "pyro",
  ...
}@args:
let
  isServer = host: lib.strings.hasPrefix "homeserver" host;
  isPersonal = host: host == "emperor" || host == "duke";
  mkConfiguration =
    host:
    {
      pkgs ? args.pkgs,
    }:
    lib.nixosSystem {
      inherit pkgs;

      specialArgs = specialArgs // rec {
        inherit host user;
        isNixOS = true;
        isDesktop = host == "emperor";
        isLaptop = host == "duke";
        isPersonal = isDesktop || isLaptop;
        isVm = host == "vm";
        isServer = isServer host;
      };

      modules = modules ++ [
        (if isServer host then ./homeserver/${host}/configuration.nix else ./${host}/configuration.nix) # Host specific configuration
        (if isServer host then ./homeserver/${host}/hardware.nix else ./${host}/hardware.nix) # Host hardware configuration
        (if isServer host then ./homeserver else { }) # Common homeserver configuration
        (if isPersonal host then ../default/personal else { })
        ../default/nixos # Default nixos configuration
        ../overlays # Access to overlays
        ../modules/nixos
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;

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
                (if isServer host then ./homeserver/${host}/home.nix else ./${host}/home.nix) # Host specific home configuration
                (if isPersonal host then ../default/personal/home.nix else { })
                ../default/home-manager # Default home configuration
                ../modules/homeManager
              ];
            };
          };
        }
        inputs.disko.nixosModules.default # Disko just in case the host uses it.
        inputs.impermanence.nixosModules.impermanence
      ];
    };
  getHomeservers = range: map (n: "homeserver-${toString n}") range;
  mkHomeservers =
    range: lib.attrsets.genAttrs (getHomeservers range) (name: mkConfiguration name { });
in
{
  emperor = mkConfiguration "emperor" { };
  duke = mkConfiguration "duke" { };
}
// mkHomeservers (lib.range 1 4)
