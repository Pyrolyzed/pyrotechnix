{ config, lib, pkgs, user, ... }:
{
  home = {
    stateVersion = "24.05";
    username = user;
    homeDirectory = "/home/${user}";
  };
}
