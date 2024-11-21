{ config, lib, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_zen;

  networking.hostName = "duke";
  networking.networkmanager.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  time.timeZone = "America/Chicago"; 
  i18n.defaultLocale = "en_US.UTF-8";


  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  users.users.pyro = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "power" ]; 
    shell = pkgs.zsh;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  programs.zsh.enable = true;

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
      parsec-bin
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "pyro" = import ./home.nix;
    };
  };
  networking.firewall.enable = false;

  system.stateVersion = "24.05"; 
}
