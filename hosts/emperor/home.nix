{ config, osConfig, lib, pkgs, ... }:

let
  projectDir = "/home/pyro/Projects/pyrotechnix";
in {
  imports = [
    ../../modules/homeManager
    ./hyprland.nix
  ];

  custom = {
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
      font = "CaskaydiaCove Nerd Font Mono";
      fontSize = 18;
    };

    shell.zsh = {
      enable = true;
      aliases = {
	ls = "lsd";
        ll = "ls -l";
	vim = "nvim";
	cd = "z";
	k = "kubectl";
      };
    };

    scripts = {
      enable = true;
      script = {
	rebuild = {
	  text = ''
	    #!/usr/bin/env bash
	    cd ${projectDir}
	    sudo nixos-rebuild switch --flake .#emperor
	  '';
	};

	rebuild-server = {
	  text = ''
	    #!/usr/bin/env bash
	    cd ${projectDir}
	    build_server () {
	      num=$1
	      ip=$2

	      echo "Rebuilding homeserver-$num..."
	      nixos-rebuild switch --flake .#homeserver-"$num" --target-host root@"$ip" > ${projectDir}/.logs/homeserver-"$num"-build.log
	      echo "Done."
	    }
	    build_server "$1" "$2"
	  '';
	};
	rebuild-servers = {
	  text = ''
	    #!/usr/bin/env bash
	    rebuild-server 1 192.168.1.151
	    rebuild-server 4 192.168.1.147
	  '';
	};

	install-remote = {
	  text = ''
	    #!/usr/bin/env bash
	    cd ${projectDir}
	    flake=$1
	    host=$2
	    nix run github:nix-community/nixos-anywhere -- --flake .#"$flake" root@"$host"
	  '';
	};
	build-iso = {
	  text = ''
	    #!/usr/bin/env bash
	    cd ${projectDir}
	    nix build .#nixosConfigurations.isoInstaller.config.system.build.isoImage
	  '';
	};
      };
    };
  };

  programs.zsh.historySubstringSearch = {
    searchDownKey = "$terminfo[kcud1]";
    searchUpKey = "$terminfo[kcuu1]";
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
  };
  
  home.sessionVariables = {
    EDITOR = "nvim";
    NIXOS_OZONE_WL = 1;
    ESDE_APPDATA_DIR = "~/.config/ES-DE";
    MANPAGER = "nvim +Man!";
    QT_QPA_PLATFORM = "wayland";
  };

  programs.home-manager.enable = true;
}
