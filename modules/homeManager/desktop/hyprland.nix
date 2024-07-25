{ config, lib, pkgs, ... }:
let
  cfg = config.custom.desktop.hyprland;
  inherit (lib) mkIf mkEnableOption mkOption mkMerge;
  inherit (lib.types) str listOf attrsOf;
in {
    options.custom.desktop.hyprland = {
        enable = mkEnableOption "Enable Hyprland.";

        keybinds = {
            mainMod = mkOption {
                type = str;
                default = "SUPER";
            }
        };

        extraConfig = mkOption {
            type = str;
            default = "";
        };
    };

    config = mkIf cfg.enable {
        wayland.windowManager.hyprland.extraConfig = ''
          $mod = "${cfg.keybinds.mainMod}";
        '';
    };
}