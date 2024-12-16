{ config, lib, pkgs, inputs, ... }:
{
  imports =
    [ 
      ./hardware-configuration.nix
      ./disk-config.nix
      inputs.home-manager.nixosModules.default
      ../default
    ];

  boot.loader.grub.enable = true;

  # Unsure about this in a server environment
  boot.kernelPackages = pkgs.linuxPackages_zen;

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
    useDHCP = false;
    networkmanager.enable = true;
    interfaces.ens18.ipv4.addresses = [ {
      address = "192.168.1.101";
      prefixLength = 24;
    } ];
    defaultGateway = "192.168.1.1";
    nameservers = [ "8.8.8.8" ];
  };

  programs.tmux.enable = true;

  virtualisation.docker.enable = true;

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "pyro" = import ./home.nix;
    };
  };

  programs.zsh.enable = true;
  users.users.pyro = {
    extraGroups = [ "wheel" "power" "docker" ]; 
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
      neovim
      git
      lsd
      unrar
      unzip
      btop
      fastfetch

      # For clearing the terminal while in SSH
      kitty
  ];

  system.stateVersion = "24.05"; 
}
