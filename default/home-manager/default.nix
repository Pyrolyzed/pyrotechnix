{ config, lib, pkgs, user, ... }:
{
  programs.ssh.addKeysToAgent = "yes";
  imports = [
    ../../modules/homeManager
  ];

  home = {
    stateVersion = "24.05";
  };
}
