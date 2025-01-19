{ config, lib, pkgs, inputs, user, ... }:
{
  imports =
    [ 
      ./disk-config.nix
      ../../../modules/nixos/virtualisation/k3s.nix
    ];

  boot.loader.grub.enable = true;

  environment.systemPackages = with pkgs; [
    kubernetes
    kubectl
  ];

  services.k3s = {
    enable = true;
    role = "agent";
    tokenFile = "/home/${user}/.k3token";
    serverAddr = "https://192.168.1.151:6443";
  };

  networking = {
    hostName = "homeserver-2";
    interfaces.ens18 = {
      ipv4.addresses = [ {
	address = "192.168.1.154";
	prefixLength = 24;
      } ];
    };
  };

  virtualisation.docker.enable = true;
  users.users.${user}.extraGroups = [ "docker" ];
}
