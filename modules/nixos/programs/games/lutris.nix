{ config, lib, pkgs, ... }:
let
  cfg = config.custom.programs.games.lutris;
  inherit (lib) mkIf mkEnableOption;
in {
    options.custom.programs.games.lutris = {
        enable = mkEnableOption "Enable Lutris.";
    };

    config = mkIf cfg.enable {
        environment.systemPackages = with pkgs; [
            lutris
        ];
    };
}