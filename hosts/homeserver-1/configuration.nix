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

  networking = {
    hostName = "homeserver-1";
    useDHCP = false;
    interfaces.ens18 = {
      ipv4.addresses = [ {
	address = "192.168.1.101";
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
