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
    dns.server = mkOption {
      type = str;
      default = "1.1.1.1";
      example = "192.168.1.136";
    };
    firewall.enable = mkEnableOption "Enable the firewall.";
  };

  config = mkIf cfg.enable { 
    networking.networkmanager.enable = true;
    networking.hostName = cfg.hostName; 
    environment.etc = {
      "resolv.conf".text = "nameserver ${cfg.dns.server}\n";
    };
    networking.firewall.enable = cfg.firewall.enable;
  };
}
