{ config, lib, ... }:
let
  cfg = config.custom.boot;
  inherit (lib) mkMerge mkEnableOption mkOption mkIf;
  inherit (lib.types) str;
in {
  options.custom.boot = {
    enable = mkEnableOption "Enable the bootloader." // { default = true; };

    systemd-boot.enable = mkEnableOption "Enable the systemd-boot bootloader.";
    grub = {
      enable = mkEnableOption "Enable the GRUB bootloader.";
      device = mkOption {
        type = str;
	default = "/dev/nvme0n1p1";
	description = "The boot device path.";
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      boot.loader.efi.canTouchEfiVariables = true;
    }

    (mkIf cfg.systemd-boot.enable {
      boot.loader.systemd-boot.enable = true;
    })

    (mkIf cfg.grub.enable {
      boot.loader.grub = {
	enable = true;
	device = cfg.grub.device;
	useOSProber = true;
      };
    })
  ]);
}
