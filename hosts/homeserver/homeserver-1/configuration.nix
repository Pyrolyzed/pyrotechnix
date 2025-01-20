{ config, lib, pkgs, inputs, user, ... }:
{
  imports =
    [ 
      ./disk-config.nix
      ../../../modules/nixos/virtualisation/k3s.nix
    ];

  # This machine advertises routes on the Tailnet so other local devices don't need tailscale
  services.tailscale = {
    enable = true;
    authKeyFile = "/home/pyro/authkey";
    extraSetFlags = [
      "--advertise-routes=192.168.1.0/24"
    ];
  };

  services.k3s = {
    role = "server";
    clusterInit = true;
  };

  boot.loader.grub.enable = true;

  networking = {
    hostName = "homeserver-1";
    interfaces.ens18 = {
      ipv4.addresses = [ {
	address = "192.168.1.151";
	prefixLength = 24;
      } ];
    };
  };
}
