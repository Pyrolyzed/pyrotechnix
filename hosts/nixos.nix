{
  inputs,
  lib,
  specialArgs,
  modules,
  user ? "pyro",
  ...
}@args:
let
  desktopName = "emperor";
  laptopName = "duke";
  isServer = host: lib.strings.hasPrefix "homeserver" host;
  isPersonal = host: host == desktopName || host == laptopName;
  mkConfiguration =
    host:
    {
      pkgs-stable ? args.pkgs-stable,
      pkgs ? args.pkgs,
    }:
    lib.nixosSystem {
      inherit pkgs;
      specialArgs = specialArgs // rec {
        inherit host user pkgs-stable;
        isNixOS = true;
        isDesktop = host == desktopName;
        isLaptop = host == laptopName;
        isPersonal = isDesktop || isLaptop;
        isVm = host == "vm";
        isServer = isServer host;
        dots = "/persist/home/${user}/Projects/pyrotechnix";
      };

      modules = modules ++ [
        (if isServer host then ./homeserver/${host}/configuration.nix else ./${host}/configuration.nix) # Host specific configuration.
        (if isServer host then ./homeserver/${host}/hardware.nix else ./${host}/hardware.nix) # Host hardware configuration.
        (if isServer host then ./homeserver else { }) # Common homeserver configuration.
        (if isPersonal host then ../default/personal else { })
        ../default/nixos # Default nixos configuration.
        ../overlays # Access to overlays.
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
              isDesktop = host == desktopName;
              isLaptop = host == laptopName;
              isVm = host == "vm";
              isServer = lib.strings.hasPrefix "homeserver" host;
              dots = "/persist/home/${user}/Projects/pyrotechnix";
            };

            users.${user} = {
              imports = [
                (if isServer host then ./homeserver/${host}/home.nix else ./${host}/home.nix) # Host specific home configuration.
                (if isPersonal host then ../default/personal/home.nix else { })
                ../default/home-manager # Default home configuration.
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
  emperor = mkConfiguration desktopName { };
  duke = mkConfiguration laptopName { };
}
// mkHomeservers (lib.range 1 4)
