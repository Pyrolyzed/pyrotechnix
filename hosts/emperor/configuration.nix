{ config, lib, pkgs, inputs, ... }:
let
  device = "/dev/disk/by-partuuid/8324c052-a744-4d7f-aad8-cd3b84a15f90";
in {
  environment.pathsToLink = [ "/share/zsh" ];
  custom = {
    impermanence = {
      enable = true;
      inherit device;
    };

    user = {
      name = "pyro";
      email = "pyrolyzed@proton.me";
      shell = pkgs.zsh;
    };

    network = {
      hostName = "emperor";
      wakeOnLan.enable = true;
    };

    boot.grub = {
      useOSProber = true;
      removable = true;
      style.resolutionEfi = "3840x2160";
    };

    gaming = {
      enable = true;
      streaming.sunshine.enable = true;
    };
  };

  virtualisation.docker.enable = true;
  environment.localBinInPath = true;


  hardware.bluetooth.enable = true;

  programs.hyprland.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  programs.virt-manager.enable = true;
  virtualisation.libvirtd.enable = true;

  programs.ssh.startAgent = true;

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
    initialPassword = "foobar";
    extraGroups = [ "libvirtd" "docker" ]; 
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  boot.initrd.kernelModules = [ "amdgpu" "dm-mirror" ];
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
    noto-fonts
    noto-fonts-cjk-sans
    nerd-fonts.jetbrains-mono
    nerd-fonts.caskaydia-cove
    poppins
  ];

  programs.tmux.enable = true;

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
      xorg.xrandr
      swww
      qalculate-gtk
      python314
      streamcontroller
      anki
      kubernetes-helm
      helmfile
      filezilla
      kdePackages.kde-cli-tools
      kubectl
      kdePackages.qtsvg
      kdePackages.qt6ct
      libreoffice
      onlyoffice-desktopeditors
      copyq
      wl-clipboard
      grim
      tealdeer
      manix
      vscode
      wikiman
      xfce.thunar
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
      btop
      protonvpn-gui
      kitty
      rofi-wayland
      discord
      spotify
      appimage-run
      obs-studio
      qbittorrent
      cifs-utils
      pipx
      vlc
      obsidian
      lvm2
      calibre
      parsec-bin
      lsd
      bat
      wine
      wineWowPackages.waylandFull
  ];
}
