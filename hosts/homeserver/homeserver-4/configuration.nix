{ config, lib, pkgs, inputs, user, ... }:
{
  imports =
    [ 
      ./disk-config.nix
    ];

  boot.loader.grub.enable = true;

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    virtualHosts."homeserver.home" = {
      locations."/" = {
        recommendedProxySettings = true;
        proxyPass = "http://longhorn.home";
      };
    };
  };

  networking = {
    hostName = "homeserver-4";
    interfaces.ens18 = {
      ipv4.addresses = [ {
	address = "192.168.1.147";
	prefixLength = 24;
      } ];
    };
  };
}
