{ config, pkgs, ... }:

{
  imports = [
    ../../modules/homeManager
  ];

  custom = {
    git = {
      enable = true;
      email = "pyrolyzed@proton.me";
      name = "Pyrolyzed";
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
  };

  home.username = "pyro";
  home.homeDirectory = "/home/pyro";
  home.stateVersion = "24.05";

  programs.zsh.initExtra = ''
    if [ -x "$(command -v tmux)" ] && [ -n "''${DISPLAY}" ] && [ -z "''${TMUX}" ]; then
      exec tmux new-session -A -s ''${USER} >/dev/null 2>&1
    fi
  '';

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
  
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.lf = {
    enable = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.file.".config/user-dirs.dirs" = {
    enable = true;
    text = ''
      #XDG_DOWNLOAD_DIR="''$HOME/Downloads"
    '';
  };

  programs.home-manager.enable = true;
}
