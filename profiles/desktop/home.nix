{ config, pkgs, ... }:

{
  imports = [
    ../../modules/homeManager
    #./hyprland.nix
    ./hyprland-new.nix
  ];

  custom = {
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
      };
    };
    scripts = {
      enable = true;
      script = {
	rebuild = {
	  text = ''
	    #!/usr/bin/env bash
	    cd /home/pyro/pyrotechnix
	    sudo nixos-rebuild switch --flake .#desktop
	  '';
	};

	build-iso = {
	  text = ''
	  #!/usr/bin/env bash
	  cd /home/pyro/pyrotechnix
	  nix build .#nixosConfigurations.isoInstaller.config.system.build.isoImage
	  '';
	};
      };
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  home.username = "pyro";
  home.homeDirectory = "/home/pyro";
  home.stateVersion = "24.05";
  programs.kitty.settings.cursor_trail = 3;
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
  };

#  home.file.".config/user-dirs.dirs" = {
#    enable = true;
#    text = ''
#      XDG_DOWNLOAD_DIR="''$HOME/Downloads"
#    '';
#  };
  home.file.".config/MangoHud/MangoHud.conf" = {
    enable = true;
    text = ''
      gpu_stats
      gpu_temp
      gpu_core_clock
      gpu_mem_clock

      cpu_stats
      cpu_temp
      cpu_mhz

      vram
      ram
      fps
      frametime

      throttling_status
      #throttling_status_graph

      gpu_name

      frame_timing

      font_size=36
      # font_scale=1.0
      font_size_text=36
      text_outline
      toggle_hud=Shift_R+F12
    '';
  };

  programs.home-manager.enable = true;
}
