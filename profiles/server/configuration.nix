{ config, lib, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    devices = [ "nodev" ];
    efiInstallAsRemovable = true;
  };

  # Unsure about this in a server environment
  boot.kernelPackages = pkgs.linuxPackages_zen;

  networking.hostName = "homeserver";
  networking.networkmanager.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  time.timeZone = "America/Chicago"; 
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.pyro = {
    isNormalUser = true;
    extraGroups = [ "wheel" "power" ]; 
  };

  environment.systemPackages = with pkgs; [
      neovim
      git

      # For clearing the terminal while in SSH
      kitty
  ];

  networking.firewall.enable = false;

  system.stateVersion = "24.05"; 
}
