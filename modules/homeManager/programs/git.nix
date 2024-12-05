{ lib, pkgs, config, ... }:
let
  inherit (lib) mkOption mkEnableOption mkIf;
  inherit (lib.types) str;
  cfg = config.custom.git;
in {
  options.custom.git = {
    enable = mkEnableOption "Enable git configuration";
    email = mkOption {
      type = str;
      description = "Your git email";
      default = custom.user.email;
    };
    name = mkOption {
      type = str;
      description = "Your git name";
      default = custom.user.name;
    };
  };

  config = mkIf cfg.enable {
    programs.git.enable = true;
    programs.git.userEmail = cfg.email;
    programs.git.userName = cfg.name;
  };
}
