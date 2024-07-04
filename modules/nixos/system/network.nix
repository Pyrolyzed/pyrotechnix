{ config, lib, ... }:

let
  cfg = config.custom.network;
  inherit (lib) mkMerge mkIf mkEnableOption mkOption;
  inherit (lib.types) str;
in {
  options.custom.network = {
    enable = mkEnableOption "Enable networking." // { default = true; };
    hostName = mkOption {
      type = str;
      default = "nixos";
    };
    dns.enable = mkEnableOption "Enable custom DNS.";
    dns.server = mkOption {
      type = str;
      default = "1.1.1.1";
      example = "192.168.1.136";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    { 
      networking.networkmanager.enable = true;
      networking.hostName = cfg.hostName; 
    }

    (mkIf cfg.dns.enable {
      environment.etc = {
        "resolv.conf".text = "nameserver ${cfg.dns.server}\n";
      };
    })
  ]);
}
