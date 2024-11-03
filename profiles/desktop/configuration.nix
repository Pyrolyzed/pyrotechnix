{ config, lib, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  boot.loader ={
    grub = {
      enable = true;
      efiSupport = true;
      devices = [ "nodev" ];
      efiInstallAsRemovable = true;
    };
  };

  networking.hostName = "overlord";
  networking.networkmanager.enable = true;  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  time.timeZone = "America/Chicago";
  
  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.enable = true;
  programs.hyprland.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  users.users.pyro = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "power" ]; 
  };

  environment.systemPackages = with pkgs; [
      neovim
      git
      firefox
      kitty
  ];

  networking.firewall.enable = false;

  system.stateVersion = "24.05"; 

}

