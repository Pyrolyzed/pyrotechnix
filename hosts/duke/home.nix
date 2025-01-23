{ config, osConfig, lib, pkgs, ... }:

let
  projectDir = "/home/pyro/Projects/pyrotechnix";
in {
  imports = [
    ../../modules/homeManager
  ];

  custom = {
    gaming = {
      enable = true;
      streaming = {
	moonlight.enable = true;
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
	    sudo nixos-rebuild switch --flake .#duke
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
      };
    };
  };

  programs.zsh.historySubstringSearch = {
    searchDownKey = "$terminfo[kcud1]";
    searchUpKey = "$terminfo[kcuu1]";
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
    MANPAGER = "nvim +Man!";
  };

  programs.home-manager.enable = true;
}
