{ config, pkgs, ... }:

{
  home.username = "pyro";
  home.homeDirectory = "/home/pyro";

  home.stateVersion = "24.05";

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.shellAliases = { 
    cd = "z";
  };

  programs.home-manager.enable = true;
}
