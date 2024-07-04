{ config, lib, ... }:

let
  cfg = config.custom.sound;
  inherit (lib) mkIf mkEnableOption;
in {
  options.custom.sound = {
    enable = mkEnableOption "Enable sound.";
  };

  config = mkIf cfg.enable {
    sound.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
    };
    hardware.pulseaudio.enable = false;
  };
}
