{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      ../default
    ];

  boot.loader.systemd-boot.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_zen;

  networking = {
    hostName = "duke";
    networkmanager.enable = true;
  };
  services.tailscale = {
    enable = true;
    authKeyFile = "/home/pyro/Documents/authkey";
    extraUpFlags = [
      "--accept-routes"
    ];
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  users.users.pyro = {
    extraGroups = [ "wheel" "video" "audio" "power" ]; 
    shell = pkgs.zsh;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
  };

  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };


  programs.zsh.enable = true;

  #fileSystems."/home/pyro/NAS" = {
  #  device = "//192.168.1.200/Storage";
  #  fsType = "cifs";
    # Plain text password because I'm lazy and also because it's not exposed to the internet and also I don't use it anywhere else.
  #  options = [ "uid=1000" "username=pyro" "password=spoons" "x-systemd.automount" "x-systemd.device-timeout=5s" "x-systemd.mount-timeout=5s" ];
  #};

  fileSystems."/home/pyro/Storage" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };

  fonts.packages = with pkgs; [ 
    noto-fonts
    noto-fonts-cjk-sans
  ];

  environment.systemPackages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.caskaydia-cove
      neovim
      git
      firefox
      calibre
      fastfetch
      lsd
      protontricks
      protonup-qt
      steamtinkerlaunch
      protonvpn-gui
      kitty
      steam
      wl-clipboard
      rofi-wayland
      vesktop
      dunst
      wl-clipboard
      copyq
      grim
      slurp
      spotify
      mangohud
      qbittorrent
      vlc
      cifs-utils
      obsidian
      parsec-bin
      moonlight-qt
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "pyro" = import ./home.nix;
    };
  };

  system.stateVersion = "24.05"; 
}
