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

  environment.systemPackages = with pkgs; [
    kubernetes
    kubectl
    kubernetes-helm
  ];
}
