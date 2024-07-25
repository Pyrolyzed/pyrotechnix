{ config, pkgs, ... }:

{
  imports = [
    ../../modules/homeManager/programs
    ../../config/homeManager.nix
  ];

  custom = {
    programs = {

      browser.firefox.enable = true;

      git = {
        userName = "Pyrolyzed";
        userEmail = "pyrolyzed@proton.me";
      };
    };
  };


  home = {
    username = "pyro";
    homeDirectory = "/home/pyro";

    stateVersion = "24.05";

    sessionVariables = {
      EDITOR = "nvim";
    };
  };
}
