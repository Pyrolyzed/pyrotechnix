{ config, lib, pkgs, user, ... }:
let
  cfg = config.custom.gaming;
  inherit (lib) mkEnableOption mkIf;
in {
  options.custom.gaming = {
    enable = mkEnableOption "Enable gaming packages";
    streaming = {
      sunshine.enable = mkEnableOption "Enable Sunshine for game streaming";
    };
  };

  config = mkIf cfg.enable {
    services.sunshine = mkIf cfg.streaming.sunshine.enable {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
  };
}
