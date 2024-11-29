{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    devices = [ "nodev" ];
    efiInstallAsRemovable = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_zen;

  networking = {
    hostName = "overlord";
    useDHCP = false;
    networkmanager.enable = true;
    interfaces.enp8s0 = {
      ipv4.addresses = [ {
	address = "192.168.1.150";
	prefixLength = 24;
      } ];
      wakeOnLan = {
        policy = [ "magic" ];
	enable = true;
      };
    };
    defaultGateway = "192.168.1.1";
    nameservers = [ "1.1.1.1" ];
  };
  services.openssh.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  time.timeZone = "America/Chicago"; 
  i18n.defaultLocale = "en_US.UTF-8";

  programs.hyprland.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  services.tailscale = {
    enable = true;
    authKeyFile = "/home/pyro/Documents/authkey";
    extraSetFlags = [
      "--advertise-routes=192.168.1.0/24"
      "--accept-routes"
    ];
  };

  services.udev.packages = with pkgs; [
    via
  ];
  
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  programs.zsh.enable = true;
  users.users.pyro = {
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "power" ]; 
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];

  fileSystems."/home/pyro/NAS" = {
    device = "//192.168.1.200/Storage";
    fsType = "cifs";
    # Plain text password because I'm lazy and also because it's not exposed to the internet and also I don't use it anywhere else.
    options = [ "uid=1000" "username=pyro" "password=spoons" "x-systemd.automount" "x-systemd.device-timeout=5s" "x-systemd.mount-timeout=5s" ];
  };

  fileSystems."/home/pyro/Storage" = {
    device = "/dev/vg1/lvol0";
    fsType = "ext4";
    # options = [ "uid=1000" "gid=100" "dmask=007" "fmask=117" ];
  };

  fonts.packages = with pkgs; [ 
    (nerdfonts.override { fonts = [ "JetBrainsMono" "CascadiaCode" ]; })
    noto-fonts
    noto-fonts-cjk-sans
  ];

  programs.tmux.enable = true;

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "pyro" = import ./home.nix;
    };
  };

  environment.systemPackages = with pkgs; [
      neovim
      git
      firefox
      ungoogled-chromium
      libreoffice
      copyq
      wl-clipboard
      grim
      slurp
      dunst
      via
      syncthing
      yt-dlp
      unrar
      unzip
      fastfetch
      pavucontrol
      btop
      protontricks
      protonup-qt
      steamtinkerlaunch
      protonvpn-gui
      kitty
      steam
      rofi-wayland
      vesktop
      spotify
      mangohud
      obs-studio
      qbittorrent
      vlc
      cifs-utils
      obsidian
      lvm2
      clonehero
      calibre
      parsec-bin
      lsd
  ];

  networking.firewall.enable = false;

  system.stateVersion = "24.05"; 
}
