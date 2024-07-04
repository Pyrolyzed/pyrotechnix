{ config, lib, ... }:
let
  cfg = config.custom.locale;
  inherit (lib) mkOption mkEnableOption mkIf mkMerge;
  inherit (lib.types) str;
in {
  options.custom.locale = {
    enable = mkEnableOption "Enable locale settings." // { default = true; };

    locale = mkOption {
      type = str;
      default = "en_US.UTF-8";
    };

    timezone = mkOption {
      type = str;
      default = "America/Chicago";
    };

    keymap = mkOption {
      type = str;
      default = "us";
    };
  };

  config = mkIf cfg.enable {
    time.timeZone = cfg.timezone;

    i18n.defaultLocale = cfg.locale;

    i18n.extraLocaleSettings = {
      LC_ADDRESS = cfg.locale;
      LC_IDENTIFICATION = cfg.locale;
      LC_MEASUREMENT = cfg.locale;
      LC_MONETARY = cfg.locale;
      LC_NAME = cfg.locale;
      LC_NUMERIC = cfg.locale;
      LC_PAPER = cfg.locale;
      LC_TELEPHONE = cfg.locale;
      LC_TIME = cfg.locale;
    };

    services.xserver.xkb.layout = cfg.keymap;
  };
}
