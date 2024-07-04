{ config, lib, pkgs, ... }:

let
  cfg = config.custom.desktop.displayManager;
  inherit (lib) mkEnableOption mkIf mkMerge;
in {
  options.custom.desktop.displayManager = {
    gdm.enable = mkEnableOption "Enable the Gnome Display Manager.";
    sddm.enable = mkEnableOption "Enable SDDM.";
    lightdm.enable = mkEnableOption "Enable LightDM.";
  };

  config = (mkMerge [
    (mkIf cfg.gdm.enable {
      services.xserver = {
        enable = true;
	displayManager.gdm.enable = true;
      };
    })
    
    (mkIf cfg.sddm.enable {
      services.displayManager.sddm.enable = true;
      services.xserver = {
        enable = true;
      };
    })
    
    (mkIf cfg.lightdm.enable {
      services.xserver = {
        enable = true;
	displayManager.lightdm.enable = true;
      };
    })
  ]);
}
