{
  config,
  lib,
  pkgs,
  inputs,
  user,
  ...
}:
{
  imports = [
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
      locations."/longhorn" = {
        proxyPass = "http://longhorn.home";
        extraConfig = ''
          	  proxy_set_header Host longhorn.home;
          	  proxy_set_header X-Forwarded-For $remote_addr;
          	'';
      };
      locations."/vaultwarden/" = {
        proxyPass = "http://vaultwarden.home/";
        extraConfig = ''
          	  proxy_set_header Host vaultwarden.home;
          	  proxy_set_header X-Forwarded-For $remote_addr;
          	'';
      };
      locations."/hoardertwo" = {
        proxyPass = "http://hoarder.home:3000/";
        extraConfig = ''
          	  proxy_set_header Host hoarder.home;
          	  proxy_set_header X-Forwarded-For $remote_addr;
          	'';
      };
    };
    resolver.addresses = [ "192.168.1.132" ];
  };

  networking = {
    hostName = "homeserver-4";
    interfaces.ens18 = {
      ipv4.addresses = [
        {
          address = "192.168.1.147";
          prefixLength = 24;
        }
      ];
    };
  };
}
