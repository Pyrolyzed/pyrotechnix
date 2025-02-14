{
  lib,
  config,
  pkgs,
  user,
  ...
}:
let
  cfg = config.custom.virtualisation.k3s;
  inherit (lib) mkEnableOption mkIf;
in
{

  options.custom.virtualisation.k3s = {
    enable = mkEnableOption "Enable K3s.";
  };

  config = mkIf cfg.enable {
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
      name = "homeserver";
      enable = true;
    };
    environment.systemPackages = with pkgs; [
      openiscsi
      kubernetes
      kubectl
      kubernetes-helm
      nfs-utils
    ];
  };
}
