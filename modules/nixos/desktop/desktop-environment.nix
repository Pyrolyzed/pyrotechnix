{ config, pkgs, lib, ... }:

let
  cfg = config.custom.desktop;
  inherit (lib) mkOption mkEnableOption mkIf mkMerge;
  inherit (lib.types) str;
in {
  options.custom.desktop = {
    gnome = {
      enable = mkEnableOption "Enable the GNOME desktop environment.";
      defaultPackages.enable = mkEnableOption "Enable the default GNOME packages.";
      tweaks.enable = mkEnableOption "Enable the GNOME Tweaks program.";
    };
    kde.enable = mkEnableOption "Enable the KDE Plasma desktop environment.";
    hyprland.enable = mkEnableOption "Enable the Hyprland tiling window manager.";
    cinnamon.enable = mkEnableOption "Enable the Cinnamon desktop environment.";
  };

  config = (mkMerge [
    {
      services.xserver.enable = true;
    }
    (mkIf cfg.gnome.enable (mkMerge [
      { 
	services.xserver = {
	  desktopManager.gnome.enable = true;
	};
      }
      (mkIf (!cfg.gnome.defaultPackages.enable) {
        environment.gnome.excludePackages = (with pkgs; [
	  gnome-photos
	  gnome-tour
	  gedit
	  cheese
	  gnome-terminal
	  epiphany
	  geary
	  evince
	  totem
	]) ++ (with pkgs.gnome; [
	  gnome-music
	  gnome-characters
	  tali
	  iagno
	  hitori
	  atomix
	]);
      })
      
      (mkIf (cfg.gnome.tweaks.enable) {
        environment.systemPackages = with pkgs; [
	  gnome-tweaks
	];
      })
    ]))

    (mkIf cfg.kde.enable {
      services.desktopManager.plasma6.enable = true;
    })

    (mkIf cfg.hyprland.enable {
      programs.hyprland.enable = true;
    })

    (mkIf cfg.cinnamon.enable {
      services.displayManager.defaultSession = "cinnamon";
      services.libinput.enable = true;
      services.xserver = {
	desktopManager.cinnamon.enable = true;
      };
    })
  ]);
}
