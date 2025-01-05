{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
      ../default
    ];

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    devices = [ "nodev" ];
    efiInstallAsRemovable = true;
  };
  virtualisation.docker.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_zen;
  environment.localBinInPath = true;
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
    nameservers = [ "192.168.1.132" ];
  };

  hardware.bluetooth.enable = true;

  programs.hyprland.enable = true;
  #services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  programs.virt-manager.enable = true;
  virtualisation.libvirtd.enable = true;

  programs.ssh.startAgent = true;

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

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  programs.zsh.enable = true;
  users.users.pyro = {
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "video" "audio" "power" "libvirtd" "docker" ]; 
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  boot.initrd.kernelModules = [ "amdgpu" "dm-mirror" ];
  services.xserver.videoDrivers = [ "amdgpu" ];

  systemd.extraConfig = ''
    DefaultTimeoutStopSec=5s
  '';

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
    noto-fonts
    noto-fonts-cjk-sans
    nerd-fonts.jetbrains-mono
    nerd-fonts.caskaydia-cove
  ];

  programs.tmux.enable = true;

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "pyro" = import ./home.nix;
    };
  };
  programs.steam.enable = true;
  systemd.user.services.lnxlink-pyro = {
    enable = true;
    description = "Manual service for lnxlink since it won't autostart";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.bash}/bin/bash -c '/home/pyro/.local/bin/lnxlink -c /home/pyro/.config/lnxlink/lnxlink.yaml'";
      ExecStop = "${pkgs.coreutils}/bin/true";
      Type = "oneshot";
    };
  };
  environment.systemPackages = with pkgs; [
      kdePackages.bluedevil
      neovim
      git
      firefox
      steamtinkerlaunch
      python314
      streamcontroller
      anki
      ciscoPacketTracer8
      arma3-unix-launcher
      filezilla
      lutris
      kdePackages.kde-cli-tools
      prismlauncher
      libreoffice
      onlyoffice-desktopeditors
      copyq
      wl-clipboard
      grim
      tealdeer
      manix
      vscode
      wikiman
      slurp
      dunst
      via
      syncthing
      yt-dlp
      unrar
      sshpass
      unzip
      fastfetch
      pavucontrol
      moonlight-qt
      btop
      protontricks
      protonup-qt
      steamtinkerlaunch
      protonvpn-gui
      kitty
      emulationstation-de
      rofi-wayland
      discord
      spotify
      appimage-run
      mangohud
      obs-studio
      qbittorrent
      cifs-utils
      pipx
      vlc
      obsidian
      lvm2
      clonehero
      calibre
      parsec-bin
      lsd
      wine
      wineWowPackages.waylandFull
      emulationstation-de
      duckstation
      flycast
      melonDS
      pcsx2
      rpcs3
      retroarchFull
      cemu
      ppsspp-qt
      dolphin-emu
  ];

  system.stateVersion = "24.05"; 
}
