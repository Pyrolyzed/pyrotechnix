{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    (import ./disk-config.nix { device = "/dev/disk/by-partuuid/8324c052-a744-4d7f-aad8-cd3b84a15f90"; })
  ];

  # TODO: Temporary spot for impermanent stuff
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    mkdir /btrfs_tmp
    mount /dev/root_vg/root /btrfs_tmp
    if [[ -e /btrfs_tmp/root ]]; then
        mkdir -p /btrfs_tmp/old_roots
        timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
        mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
    fi

    delete_subvolume_recursively() {
        IFS=$'\n'
        for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
            delete_subvolume_recursively "/btrfs_tmp/$i"
        done
        btrfs subvolume delete "$1"
    }

    for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +15); do
        delete_subvolume_recursively "$i"
    done

    btrfs subvolume create /btrfs_tmp/root
    umount /btrfs_tmp
  '';

  fileSystems."/persist".neededForBoot = true;
  environment.persistence."/persist/system" = {
    hideMounts = true;
    directories = [
      "/etc/nixos"
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
    ];
    files = [
      "/etc/machine-id"
    ];
  };
  programs.fuse.userAllowOther = true;

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    devices = [ "nodev" ];
    efiInstallAsRemovable = true;
    useOSProber = true;
    theme = "${pkgs.catppuccin-grub.overrideAttrs (old: {
      patches = (old.patches or []) ++ [
        ../../patches/grub_patch.patch
      ];
    })}";
    gfxmodeEfi = "3840x2160";
    font = "${pkgs.poppins}/share/fonts/truetype/Poppins-Regular.ttf";
    fontSize = 24;
    extraConfig = ''
      set timeout=-1
    '';
  };

  virtualisation.docker.enable = true;
  environment.localBinInPath = true;
  services.ollama = {
    enable = true;
    loadModels = [ "llama3" ];
  };
  networking = {
    hostName = "emperor";
    useDHCP = false;
    #networkmanager.enable = true;
    interfaces.enp8s0 = {
      ipv4.addresses = [ {
      	address = "192.168.1.97";
	prefixLength = 24;
      } ];
      wakeOnLan = {
        policy = [ "magic" ];
	enable = true;
      };
    };
    defaultGateway = {
      address = "192.168.1.1";
      interface = "enp8s0";
    };
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
    initialPassword = "foobar";
    extraGroups = [ "wheel" "video" "audio" "power" "libvirtd" "docker" ]; 
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
      swww
      qalculate-gtk
      steamtinkerlaunch
      python314
      streamcontroller
      anki
      arma3-unix-launcher
      filezilla
      lutris
      kdePackages.kde-cli-tools
      prismlauncher
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
}
