{ config, lib, pkgs, inputs, user, ... }:
{
  imports =
    [ 
      ./disk-config.nix
    ];

  # This machine advertises routes on the Tailnet so other local devices don't need tailscale
  services.tailscale = {
    enable = true;
    authKeyFile = "/home/pyro/authkey";
    extraSetFlags = [
      "--advertise-routes=192.168.1.0/24"
    ];
  };

  boot.loader.grub.enable = true;

  services.k3s = {
    enable = true;
    role = "server";
    tokenFile = "/home/${user}/.k3token";
    clusterInit = true;
  };

  environment.systemPackages = with pkgs; [
    kubernetes
    kubectl
  ];

  networking = {
    hostName = "homeserver-1";
    interfaces.ens18 = {
      ipv4.addresses = [ {
	address = "192.168.1.151";
	prefixLength = 24;
      } ];
    };
  };

  virtualisation.docker.enable = true;
  users.users.${user}.extraGroups = [ "docker" ];
}
