{ config, lib, pkgs, user, ... }:
let
  cfg = config.custom.gaming.streaming;
  inherit (lib) mkIf mkEnableOption mkMerge;
  createStreamingConfig = pkg: setting: { 
    home.packages = mkIf cfg.${setting}.enable [ pkg ]; 
  };
in {
  options.custom.gaming.streaming = {
    moonlight.enable = mkEnableOption "Enable moonlight for streaming other devices.";
  };

  config = (mkMerge [
    (createStreamingConfig pkgs.moonlight-qt "moonlight")
  ]);
}
