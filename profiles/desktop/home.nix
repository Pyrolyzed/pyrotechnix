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
  };

  home.username = "pyro";
  home.homeDirectory = "/home/pyro";

  home.stateVersion = "24.05";

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };


  programs.home-manager.enable = true;
}
