{ config, lib, ... }:
let
  cfg = config.custom.gaming;
  inherit (lib) mkIf mkEnableOption;
in {
  imports = [
    ./emulation.nix
    ./utilities.nix
    ./launchers.nix
    ./games.nix
    ./streaming.nix
  ];

  options.custom.gaming = {
    enable = mkEnableOption "Enable gaming!";
  };
}
