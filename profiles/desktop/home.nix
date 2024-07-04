{ config, pkgs, ... }:

{
  imports = [
    ../../modules/homeManager/programs/development/git.nix
  ];

  custom = {
    programs = {
      git = {
        userName = "Pyrolyzed";
        userEmail = "pyrolyzed@proton.me";
      };
    };
  };

  programs = {
    home-manager.enable = true;
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
