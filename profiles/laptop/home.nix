{ config, pkgs, ... }:

{
  imports = [
    ../../modules/homeManager
  ];

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
