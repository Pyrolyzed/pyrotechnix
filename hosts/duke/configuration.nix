{ config, lib, pkgs, inputs, ... }:
let
  device = "/dev/nvme0n1";
in {

  imports = [
    (import ./disk-config.nix { inherit device;  })
  ];

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
      hostName = "duke";
      interface = "enp59s0";
      networkManager.enable = true;
      ip.address = "192.168.1.96";
      wakeOnLan.enable = true;
    };

    boot.grub = {
      useOSProber = true;
      removable = true;
      style.resolutionEfi = "1920x1080";
    };

    gaming.enable = true;
  };

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
  
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  programs.zsh.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  fileSystems."/home/pyro/NAS" = {
    device = "//192.168.1.200/Storage";
    fsType = "cifs";
    # Plain text password because I'm lazy and also because it's not exposed to the internet and also I don't use it anywhere else.
    options = [ "uid=1000" "username=pyro" "password=spoons" "x-systemd.automount" "x-systemd.device-timeout=5s" "x-systemd.mount-timeout=5s" ];
  };

  fileSystems."/home/pyro/Storage" = {
    device = "dev/sda1";
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

  environment.systemPackages = with pkgs; [
      kdePackages.bluedevil
      neovim
      git
      firefox
      xorg.xrandr
      swww
      qalculate-gtk
      python314
      anki
      kubernetes-helm
      helmfile
      kdePackages.kde-cli-tools
      kubectl
      kdePackages.qtsvg
      kdePackages.qt6ct
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
      vesktop
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
