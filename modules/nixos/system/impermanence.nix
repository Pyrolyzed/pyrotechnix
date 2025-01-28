{ config, lib, pkgs, ... }:
let
  cfg = config.custom.impermanence;
  inherit (lib) mkEnableOption mkOption mkIf;
  inherit (lib.types) str listOf;
in {
  options.custom.impermanence = {
    enable = mkEnableOption "Enable impermanence";
    device = mkOption {
      type = str;
      description = "Root disk for impermanence";
      default = "/dev/sda";
      example = "/dev/sda";
    };
    extraPersistDirectories = mkOption {
      type = listOf str;
      description = "Extra directories to persist";
      default = [ ];
      example = [ "/etc/persist" "/etc/persist2" ];
    };
    extraPersistFiles = mkOption {
      type = listOf str;
      description = "Extra files to persist";
      default = [ ];
      example = [ "/etc/persistFile" "/etc/persistFile2" ];
    };
  };
  config = mkIf cfg.enable {
    boot.initrd.postDeviceCommands = lib.mkAfter ''
      mkdir /btrfs_tmp
      mount /dev/root_vg/root /btrfs_tmp
      if [[ -e /btrfs_tmp/root ]]; then
	  mkdir -p /btrfs_tmp/old_roots
	  timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
	  mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
      fi

      delete_subvolume_recursively() {
	  IFS=$'\n'
	  for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
	      delete_subvolume_recursively "/btrfs_tmp/$i"
	  done
	  btrfs subvolume delete "$1"
      }

      for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +15); do
	  delete_subvolume_recursively "$i"
      done

      btrfs subvolume create /btrfs_tmp/root
      umount /btrfs_tmp
    '';

    fileSystems."/persist".neededForBoot = true;
    environment.persistence."/persist/system" = {
      hideMounts = true;
      directories = [
	"/etc/nixos"
	"/var/log"
	"/var/lib/bluetooth"
	"/var/lib/nixos"
	"/var/lib/systemd/coredump"
	{ directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
      ] ++ cfg.extraPersistDirectories;
      files = [
	"/etc/machine-id"
      ] ++ cfg.extraPersistFiles;
    };
    programs.fuse.userAllowOther = true;
  };
}
