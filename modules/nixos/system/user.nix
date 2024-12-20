{ lib, pkgs, config, ... }:
let
  inherit (lib) mkOption mkEnableOption mkIf replaceStrings toLower toOneWord;
  inherit (lib.types) str path listOf;
  cfg = config.custom.user;
in {
  options.custom.user = {
    enable = mkEnableOption "Enable user configuration" // { default = true; }; 

    name = mkOption {
      type = str;
      default = "John Doe";
    };

    email = mkOption {
      type = str;
      default = "your@email.com";
    };
    
    groups = mkOption {
      type = listOf str;
      default = [ "wheel" "power" "video" "audio" ];
    };

    home = mkOption {
      type = path;
      default = "/home/${toLower toOneWord cfg.name}/"
    };

    shell = mkOption {
      type = str;
      default = "bash";
    };
  };

  config = mkIf cfg.enable {
    users.users.${toLower replaceStrings [" "] [""] cfg.name} = {
      name = cfg.name;
      home = cfg.home;
      isNormalUser = true;
      extraGroups = cfg.groups;
      shell = cfg.shell;
    };
  };
}
