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

  boot.kernelPackages = pkgs.linuxPackages_zen;

  networking.hostName = "overlord";
  networking.networkmanager.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  time.timeZone = "America/Chicago"; 
  i18n.defaultLocale = "en_US.UTF-8";

  programs.hyprland.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  users.users.pyro = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "power" ]; 
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  fileSystems."/home/pyro/NAS" = {
    device = "//192.168.1.200/Storage";
    fsType = "cifs";
    # Plain text password because I'm lazy and also because it's not exposed to the internet and also I don't use it anywhere else.
    options = [ "uid=1000" "username=pyro" "password=spoons" ];
  };
  environment.systemPackages = with pkgs; [
      neovim
      git
      firefox
      kitty
      steam
      grim
      slurp
      copyq
      wl-clipboard
      rofi-wayland
      vesktop
      dunst
      mangohud
      obs-studio
      qbittorrent
      vlc
      cifs-utils
  ];

  networking.firewall.enable = false;

  system.stateVersion = "24.05"; 

}
