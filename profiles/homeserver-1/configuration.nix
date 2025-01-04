{ config, lib, pkgs, inputs, ... }:
let 
  kubeMasterIP = "127.0.0.1";
  kubeMasterHostname = "homeserver-1";
  kubeMasterAPIServerPort = 6443;
in {
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
      "--accept-routes"
    ];
  };

  networking = {
    hostName = "homeserver-1";
    interfaces.ens18.ipv4.addresses = [ {
      address = "192.168.1.101";
      prefixLength = 24;
    } ];
  };


  environment.systemPackages = with pkgs; [
    kubectl
    kubernetes
  ];

  services.kubernetes = {
    roles = [ "master" "node" ];
    masterAddress = kubeMasterHostname;
    apiserverAddress = "https://${kubeMasterHostname}:${toString kubeMasterAPIServerPort}";
    easyCerts = true;
    apiserver = {
      securePort = kubeMasterAPIServerPort;
      advertiseAddress = kubeMasterIP;
    };
    addons.dns.enable = true;
  };

  virtualisation.docker.enable = true;

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "pyro" = import ./home.nix;
    };
  };

  users.users.pyro = {
    extraGroups = [ "wheel" "power" "docker" ]; 
  };
}
