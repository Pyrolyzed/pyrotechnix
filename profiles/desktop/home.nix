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
  };

  home.username = "pyro";
  home.homeDirectory = "/home/pyro";

  home.stateVersion = "24.05";

  programs.zsh.enable = true;
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.zsh.shellAliases = { 
    cd = "z";
  };

  programs.home-manager.enable = true;
}
