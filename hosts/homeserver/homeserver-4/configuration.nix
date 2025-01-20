{ config, lib, pkgs, inputs, user, ... }:
{
  imports =
    [ 
      ./disk-config.nix
    ];

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    virtualHosts."homeserver.local" = {
      locations."/" = {
        recommendedProxySettings = true;
        proxyPass = "http://longhorn.local";
      };
    };
  };

  boot.loader.grub.enable = true;

  networking = {
    hostName = "homeserver-4";
    interfaces.ens18 = {
      ipv4.addresses = [ {
	address = "192.168.1.190";
	prefixLength = 24;
      } ];
    };
  };
}
