{ config, lib, pkgs, inputs, ... }:

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

  networking.hostName = "duke";
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

  fonts.packages = with pkgs; [ 
    (nerdfonts.override { fonts = [ "JetBrainsMono" "CascadiaCode" ]; })
  ];

  environment.systemPackages = with pkgs; [
      neovim
      git
      firefox
      protontricks
      protonup-qt
      steamtinkerlaunch
      protonvpn-gui
      kitty
      steam
      grim
      slurp
      copyq
      wl-clipboard
      rofi-wayland
      vesktop
      dunst
      spotify
      mangohud
      qbittorrent
      vlc
      cifs-utils
      obsidian
      calibre
      parsec-bin
  ];

  networking.firewall.enable = false;

  system.stateVersion = "24.05"; 

}
