{ config, lib, pkgs, inputs, ... }:
let
  inherit (lib) mkDefault;
in {
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  boot.loader.grub.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_zen;

  networking = {
    useDHCP = false;
    networkmanager.enable = true;
    defaultGateway = mkDefault "192.168.1.1";
    nameservers = mkDefault [ "192.168.1.132" ];
  };

  programs.tmux.enable = true;

  users.users.pyro = {
    extraGroups = mkDefault [ "wheel" "power" ]; 
  };

  environment.systemPackages = with pkgs; [
      neovim
      git
      unrar
      unzip
      btop

      # For clearing the terminal while in SSH
      kitty
  ];

  system.stateVersion = "24.05"; 
}
