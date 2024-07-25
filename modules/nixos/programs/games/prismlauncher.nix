{ config, lib, pkgs, ... }:
let
  cfg = config.custom.programs.games.prismlauncher;
  inherit (lib) mkIf mkEnableOption;
in {
    options.custom.programs.games.prismlauncher = {
        enable = mkEnableOption "Enable Prism Launcher.";
    };

    config = mkIf cfg.enable {
        environment.systemPackages = with pkgs; [
            prismlauncher   
        ];
    };
}