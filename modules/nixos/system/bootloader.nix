{ lib, pkgs, config, ... }:
let
  inherit (lib) mkEnableOption mkIf mkMerge;
  inherit (lib.types) listOf str int package;
  cfg = config.custom.boot;
in {
  options.custom.boot = {
    systemd-boot = {
      enable = mkEnableOption "Enable systemd-boot";
    };

    grub = {
      enable = mkEnableOption "Enable GRUB" // { default = true; };
      efi = mkEnableOption "Enable EFI support" // { default = true; };
      devices = mkOption {
        type = listOf str;
	default = [ "nodev" ];
      };
      removable = mkEnableOption "Install GRUB with removable flag";
      useOSProber = mkEnableOption "Use the OS Prober";

      style = {
        theme = mkOption {
	  type = package;
	  description = "The theme package to be used by GRUB";
	  default = "${pkgs.catppuccin-grub.overrideAttrs (old: {
	    patches = (old.patches or []) ++ [
	      ../../patches/grub_patch.patch
	    ];
	  })}";
	};
	resolutionEfi = mkOption {
	  type = str;
	  description = "The resolution of the GRUB screen";
	  default = "1920x1080";
	};
	font = mkOption {
	  type = str;
	  description = "The font to be used by GRUB";
	  default = "${pkgs.poppins}/share/fonts/truetype/Poppins-Regular.ttf";
	};
	fontSize = mkOption {
	  type = int;
	  description = "The font size of GRUB";
	  default = 24;
	};
	extraConfig = mkOption {
	  type = str;
	  description = "Extra GRUB configuration";
	  default = ''
	    set timeout=-1
	  '';
	};
      };
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
	efiSupport = cfg.grub.efi;
	devices = cfg.grub.devices;
	efiInstallAsRemovable = cfg.grub.removable;
	useOSProber = cfg.grub.useOSProber;
	theme = cfg.grub.style.theme;
	gfxmodeEfi = cfg.grub.style.resolutionEfi;
	font = cfg.grub.style.font;
	fontSize = cfg.grub.style.fontSize;
	extraConfig = cfg.grub.style.extraConfig;
      };
    })
  ]);
}
