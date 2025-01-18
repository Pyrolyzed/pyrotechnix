{ config, lib, pkgs, inputs, user, ... }:
{
  imports =
    [ 
      ./disk-config.nix
    ];

  boot.loader.grub.enable = true;

  environment.systemPackages = with pkgs; [
    kubernetes
    kubectl
  ];

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
