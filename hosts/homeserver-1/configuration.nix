{ config, lib, pkgs, inputs, ... }:
{
  imports =
    [ 
      ./disk-config.nix
      ../homeserver-common
      inputs.home-manager.nixosModules.default
    ];

  # This machine advertises routes on the Tailnet so other local devices don't need tailscale
  services.tailscale = {
    enable = true;
    authKeyFile = "/home/pyro/authkey";
    extraSetFlags = [
      "--advertise-routes=192.168.1.0/24"
    ];
  };

  networking = {
    hostName = "homeserver-1";
    interfaces.ens18.ipv4.addresses = [ {
      address = "192.168.1.101";
      prefixLength = 24;
    } ];
  };

  virtualisation.docker.enable = true;

  users.users.pyro = {
    extraGroups = [ "wheel" "power" "docker" ]; 
  };
}
