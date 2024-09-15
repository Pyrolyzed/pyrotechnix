{ config, lib, ... }:

let
  cfg = config.custom.sound;
  inherit (lib) mkIf mkEnableOption mkMerge;
in {
  options.custom.sound = {
    enable = mkEnableOption "Enable sound.";
    pipewire = {
      enable = mkEnableOption "Enable Pipewire." // { default = true; };
      pulse.enable = mkEnableOption "Enable PulseAudio support." // { default = true; };
      alsa.enable = mkEnableOption "Enable ALSA support." // { default = true; };
      jack.enable = mkEnableOption "Enable Jack support.";
    };
    pulseaudio.enable = mkEnableOption "Enable PulseAudio.";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      security.rtkit.enable = true;
    }

    (mkIf (cfg.pipewire.enable && cfg.pulseaudio.enable) {
      assertions = [
        {
          assertion = false;
          message = "Pipewire and PulseAudio cannot be enabled at the same time.";
        }
      ];
    })

    (mkIf cfg.pipewire.enable {
      sound.enable = false;
      services.pipewire = {
        enable = true;
        pulse.enable = cfg.pipewire.pulse.enable;
        alsa.enable = cfg.pipewire.alsa.enable;
        alsa.support32Bit = cfg.pipewire.alsa.enable;
        jack.enable = cfg.pipewire.jack.enable;
      }
    })
    
    (mkIf cfg.pulseaudio.enable {
      sound.enable = true;
      hardware.pulseaudio.enable = true;
    })

  ]);
}
