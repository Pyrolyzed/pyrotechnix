{ config, lib, pkgs, inputs, user, ... }:
{
  imports =
    [ 
      ./disk-config.nix
    ];

  boot.loader.grub.enable = true;

  # This machine advertises routes on the Tailnet so other local devices don't need tailscale
  services.tailscale = {
    enable = true;
    authKeyFile = "/home/pyro/.tskey";
    extraUpFlags = [
      "--advertise-routes=192.168.1.0/24"
    ];
  };

  services.nginx = {
    enable = true;
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
