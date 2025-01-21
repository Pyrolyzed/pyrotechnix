{ config, lib, pkgs, user, ... }:
{
  xdg.userDirs = {
    enable = true;
    documents = "/home/${user}/Storage/Media/Documents";
    download = "/home/${user}/Storage/Downloads";
    pictures = "/home/${user}/Storage/Media/Pictures";
    videos = "/home/${user}/Storage/Media/Videos";
    extraConfig = {
      XDG_PROJECTS_DIR = "/home/${user}/Projects";
    };
    publicShare = null;
    desktop = null;
    music = null;
    templates = null;
  };

  home = {
    stateVersion = "24.05";
    username = user;
    homeDirectory = "/home/${user}";
  };
}
