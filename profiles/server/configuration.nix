{ config, lib, pkgs, inputs, ... }:
let
  inherit (lib) mkDefault;
in {
  imports =
    [ 
      ../default
    ];

  boot.loader.grub.enable = true;

  # Unsure about this in a server environment
  boot.kernelPackages = pkgs.linuxPackages_zen;

  networking = {
    useDHCP = false;
    networkmanager.enable = true;
    defaultGateway = mkDefault "192.168.1.1";
    nameservers = mkDefault [ "8.8.8.8" ];
  };

  programs.tmux.enable = true;

  programs.zsh.enable = true;
  users.users.pyro = {
    extraGroups = mkDefault [ "wheel" "power" ]; 
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
