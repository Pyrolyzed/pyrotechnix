{ pkgs, lib, config, ... }:

let
  cfg = config.custom.programs.git;
  inherit (lib) mkOption mkEnableOption mkIf;
  inherit (lib.types) str;
in {
  options.custom.programs.git = {
    enable = mkEnableOption "Enable Git." // { default = true; };

    userName = mkOption {
      type = str;
      default = "gituser";
      description = "Your Git username.";
    };

    userEmail = mkOption {
      type = str;
      default = "user@example.com";
      description = "Your Git email.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      git
    ];
   
    programs.git = {
      enable = true;
      userName = cfg.userName;
      userEmail = cfg.userEmail;
    };
  };
}
