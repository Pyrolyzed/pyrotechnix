{ config, lib, pkgs, ... }:
let
  cfg = config.custom.network;
  inherit (lib) mkEnableOption mkOption mkIf;
  inherit (lib.types) str int;
in {
  options.custom.network = {
    enable = mkEnableOption "Enable network configuration" // { default = true; };
    dhcp.enable = mkEnableOption "Enable the use of DHCP";
    wakeOnLan.enable = mkEnableOption "Enable Wake-On-LAN support via magic packets";
    networkManager.enable = mkEnableOption "Enable NetworkManager";
    hostName = mkOption {
      type = str;
      description = "The network hostname of the PC";
      default = "nixos";
    };
    interface = mkOption {
      type = str;
      description = "The main network interface used in configuration";
      default = "enp8s0";
    };
    ip = {
      address = mkOption {
        type = str;
	description = "The main IPv4 address of the PC";
	default = "192.168.1.97";
      };
      prefixLength = mkOption {
        type = int;
	description = "The prefix length of the IPv4 address";
	default = 24;
      };
    };
    gateway = mkOption {
      type = str;
      description = "The IP address of the network gateway";
      default = cfg.interface;
    };
  };

  config = mkIf cfg.enable {
    networking = {
      hostName = cfg.hostName;
      networkmanager.enable = cfg.networkManager.enable;
      useDHCP = cfg.dhcp;
      interfaces.${cfg.interface} = {
	ipv4.addresses = [ {
	  address = cfg.ip.address; 
	  prefixLength = cfg.ip.prefixLength;
	} ];
	wakeOnLan = {
	  enable = cfg.wakeOnLan.enable;
	  policy = [ "magic" ];
	};
      };
      defaultGateway = {
	address = cfg.gateway;
	interface = cfg.interface;
      };
    };
  };
}
