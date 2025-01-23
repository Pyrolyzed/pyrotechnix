{ config, lib, pkgs, user, ... }:
{
  programs.ssh.addKeysToAgent = "yes";

  home = {
    stateVersion = "24.05";
    username = user;
    homeDirectory = "/home/${user}";
  };
}
