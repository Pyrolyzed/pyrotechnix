{ config, lib, pkgs, ... }:
let
  cfg = config.custom.programs.games.steam;
  inherit (lib) mkIf mkEnableOption;
in {
    options.custom.programs.games.steam = {
        enable = mkEnableOption "Enable Steam.";
    };

    config = mkIf cfg.enable {
        programs.steam = {
            enable = true;
            remotePlay.openFirewall = true;
            dedicatedServer.openFirewall = true;
            localNetworkGameTransfers.openFirewall = true;
        };
    };
}