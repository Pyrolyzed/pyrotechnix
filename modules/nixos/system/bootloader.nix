{ lib, pkgs, config, ... }:
let
  inherit (lib) mkEnableOption mkIf mkMerge;
  inherit (lib.types) str
  cfg = config.custom.boot;
in {
  options.custom.boot = {
    systemd-boot = {
      enable = mkEnableOption "Enable systemd-boot";
    };

    grub = {
      enable = mkEnableOption "Enable GRUB";
      device = mkOption {
        type = types.str;
	default = "nodev";
      };
      removable = mkEnableOption "Install GRUB with removable flag";
      useOSProber = mkEnableOption "Use the OS Prober";
    };
  };

  config = (mkMerge [
    (mkIf (!cfg.grub.enable && !cfg.systemd-boot.enable) {
      assertions = [
        {
	  assertion = false;
	  message = "You must have a bootloader enabled!";
	}
      ];
    })

    (mkIf (cfg.grub.enable && cfg.systemd-boot.enable) {
      assertions = [
        {
	  assertion = false;
	  message = "GRUB and Systemd-boot cannot be enabled at the same time.";
	}
      ];
    })

    (mkIf cfg.systemd-boot.enable {
      boot.loader = {
        efi.canTouchEfiVariables = true;
	systemd-boot.enable = true;
      };
    })

    (mkIf cfg.grub.enable {
      boot.loader.grub = {
        enable = true;
	device = cfg.grub.device;
	efiInstallAsRemovable = cfg.grub.removable;
	useOSProber = cfg.grub.useOSProber;
      };
    })
  ]);
}
