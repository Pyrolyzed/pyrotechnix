{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ../../modules/nixos/gaming
    (import ../../modules/nixos/system/impermanence.nix { device = "/dev/nvme0n1" });
  ];

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    devices = [ "nodev" ];
    theme = "${pkgs.catppuccin-grub.overrideAttrs (old: {
      patches = (old.patches or []) ++ [
        ../../patches/grub_patch.patch
      ];
    })}";
    gfxmodeEfi = "1920x1080";
    font = "${pkgs.poppins}/share/fonts/truetype/Poppins-Regular.ttf";
    fontSize = 24;
    extraConfig = ''
      set timeout=-1
    '';
  };

  environment.pathsToLink = [ "/share/zsh" ];

  custom = {
    gaming = {
      enable = true;
    };
  };

  environment.localBinInPath = true;

  networking = {
    hostName = "duke";
    useDHCP = false;
    interfaces.enp8s0 = {
      ipv4.addresses = [ {
      	address = "192.168.1.96";
	prefixLength = 24;
      } ];
    };
    defaultGateway = {
      address = "192.168.1.1";
      interface = "enp8s0";
    };
  };

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
  users.users.pyro = {
    shell = pkgs.zsh;
    initialPassword = "foobar";
    extraGroups = [ "libvirtd" ]; 
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  fileSystems."/home/pyro/NAS" = {
    device = "//192.168.1.200/Storage";
    fsType = "cifs";
    options = [ "uid=1000" "username=pyro" "password=spoons" "x-systemd.automount" "x-systemd.device-timeout=5s" "x-systemd.mount-timeout=5s" ];
  };

  fileSystems."/home/pyro/Storage" = {
    device = "/dev/sda1";
    fsType = "ext4";
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
      anki
      kubernetes-helm
      helmfile
      filezilla
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
