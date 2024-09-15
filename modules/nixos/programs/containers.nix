{ config, lib, pkgs, ... }:
let
  cfg = config.custom.programs.containers.docker;
  inherit (lib) mkIf mkEnableOption;
in {
    options.custom.programs.containers.docker = {
        enable = mkEnableOption "Enable Docker.";
    };

    config = mkIf cfg.enable {
        virtualisation.docker.enable = true;
    };
}
