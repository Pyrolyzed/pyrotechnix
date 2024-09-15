{ config, lib, ... }:

let
  cfg = config.custom.user;
  inherit (lib) mkIf mkEnableOption mkOption;
  inherit (lib.types) listOf str;
in {
  options.custom.user = {
    enable = mkEnableOption "Enable user account." // { default = true; };
    name = mkOption { type = str; default = "user"; };
    groups = mkOption { type = listOf str; default = [ "wheel" "video" "audio"]; };
    home = mkOption { type = str; default = "/home/${lib.toLower cfg.name}"; };
  };

  config = mkIf cfg.enable {
    users.users.${lib.toLower cfg.name} = {
      isNormalUser = true;

      home = cfg.home;
      extraGroups = cfg.groups;
      description = cfg.name;
    };
  };
}
