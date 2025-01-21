{ lib, config, pkgs, user, ... }:
{
  services.k3s = {
    enable = true;
    tokenFile = "/home/${user}/.k3token";
    extraFlags = [
      "--docker"
    ];
  };

  # Fixes for longhorn
  systemd.tmpfiles.rules = [
    "L+ /usr/local/bin - - - - /run/current-system/sw/bin/"
  ];
  virtualisation.docker.logDriver = "json-file";
  services.openiscsi = {
    name = "homeserver-1";
    enable = true;
  };
  environment.systemPackages = with pkgs; [
    openiscsi
    kubernetes
    kubectl
    kubernetes-helm
    nfs-utils
  ];
}
