{
  config,
  lib,
  pkgs,
  user,
  ...
}:
{
  imports = [
    ../../modules/homeManager/gaming
    ./hyprland.nix
  ];
  home.persistence."/persist/home/${user}" = {
    directories = [
      "Media"
      "Projects"
      ".config/steamtinkerlaunch"
      ".local/share/PrismLauncher"
      ".config/obs-studio"
      ".ssh"
      ".config/unity3d"
      ".config/vesktop"
      ".local/share/zoxide"
      ".mozilla"
      ".var"
      ".config/rofi"
      ".config/discord"
      ".config/a3unixlauncher"
      ".local/share/Steam"
      ".local/state/wireplumber"
      ".cache/spotify"
      ".clonehero"
      ".cache/mozilla"
      ".cache/swww"
      ".paradoxlauncher"
      ".local/share/Paradox Interactive"
      ".config/spotify"
      ".config/obsidian"
      ".config/Thunar"
      ".config/sunshine"
      ".config/cosmic"
      # Emulators
      ".config/ES-DE"
      ".cache/rpcs3"
      ".config/Cemu"
      ".config/flycast"
      ".config/melonDS"
      ".config/dolphin-emu"
      ".config/ppsspp"
      ".config/retroarch"
      ".config/rpcs3"
      ".local/share/Cemu"
      ".local/share/dolphin-emu"
      ".local/share/duckstation"
      ".local/share/flycast"
      ".local/share/citron"
      ".local/share/citra-emu"
    ];
    files = [
      ".zsh_history"
    ];
  };

  custom = {
    impermanence.enable = true;
    gaming = {
      enable = true;
      emulation.enable = true;
      streaming = {
        moonlight.enable = true;
      };
      games = {
        armaLauncher.enable = true;
        cloneHero.enable = true;
      };
    };

    git = {
      enable = true;
      email = "pyrolyzed@proton.me";
      name = "Pyrolyzed";
    };

    kitty = {
      enable = true;
      backgroundOpacity = 0.8;
      font = "JetBrainsMono Nerd Font";
      fontSize = 18;
    };

    shell.zsh = {
      enable = true;
      aliases = {
        ls = "lsd";
        ll = "ls -l";
        vim = "nix run ~/Projects/pyrotechnix";
        vi = "nix run ~/Projects/pyrotechnix";
        cd = "z";
        k = "kubectl";
      };
    };
  };

  programs.zsh.historySubstringSearch = {
    searchDownKey = "$terminfo[kcud1]";
    searchUpKey = "$terminfo[kcuu1]";
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita-dark";
    };
  };

  qt = {
    enable = true;
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt6;
    };
    platformTheme.name = "qtct";
  };

  home.pointerCursor = {
    gtk.enable = true;
    hyprcursor.enable = true;
    hyprcursor.size = 24;
    x11.enable = true;
    x11.defaultCursor = "left_ptr";
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };
  home.packages = with pkgs; [
    pinta
  ];
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.ranger = {
    enable = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.kitty.settings = {
    window_padding_width = 10;
    window_padding_height = 5;
    enable_audio_bell = false;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    NIXOS_OZONE_WL = 1;
    ESDE_APPDATA_DIR = "~/.config/ES-DE";
    MANPAGER = "nvim +Man!";
    QT_QPA_PLATFORM = "wayland";
  };

  systemd.user.services =
    let
      graphicalTarget = config.wayland.systemd.target;
    in
    {
      swww = {
        Install.WantedBy = [ graphicalTarget ];
        Unit = {
          Description = "Wayland wallpaper daemon";
          After = [ graphicalTarget ];
          PartOf = [ graphicalTarget ];
        };
        Service = {
          ExecStart = lib.getExe' pkgs.swww "swww-daemon";
          Restart = "on-failure";
        };
      };
    };

  programs.home-manager.enable = true;
}
