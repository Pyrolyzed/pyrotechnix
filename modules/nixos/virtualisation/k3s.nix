{ lib, config, pkgs, user, ... }:
{
  services.k3s = {
    enable = true;
    role = "server";
    tokenFile = "/home/${user}/.k3token";
    clusterInit = true;
    extraFlags = [
      "--docker"
    ];
  };

  environment.systemPackages = with pkgs; [
    kubernetes
    kubectl
    kubernetes-helm
  ];
}
