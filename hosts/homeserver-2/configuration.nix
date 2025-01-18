{ config, lib, pkgs, inputs, user, ... }:
{
  imports =
    [ 
      ./disk-config.nix
    ];

  boot.loader.grub.enable = true;

  networking = {
    hostName = "homeserver-2";
    useDHCP = false;
    interfaces.ens18 = {
      ipv4.addresses = [ {
	address = "192.168.1.102";
	prefixLength = 24;
      } ];
      wakeOnLan = {
        enable = true;
        policy = [ "magic" ];
      };
    };
    defaultGateway = {
      address = "192.168.1.1";
      interface = "ens18";
    };
  };

  programs.tmux.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    git
    unrar
    unzip

    # For clearing the terminal while in SSH
    kitty
  ];

  virtualisation.docker.enable = true;
  users.users.${user}.extraGroups = [ "docker" ];
}
