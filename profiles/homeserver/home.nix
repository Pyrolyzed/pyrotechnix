{ config, pkgs, userSettings, ... }:

{
  imports = [
    ../../modules/homeManager/programs
    ../../config/homeManager.nix
  ];

  custom = {
    programs = {
      git = {
        userName = "Pyrolyzed";
        userEmail = userSettings.email;
      };
    };
  };

  home = {
    username = userSettings.username;
    homeDirectory = "/home/${userSettings.username}";

    stateVersion = "24.05";

    sessionVariables = {
      EDITOR = "nvim";
    };
  };
}
