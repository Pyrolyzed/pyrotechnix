{
  config,
  lib,
  ...
}:
let
  cfg = config.custom.gaming;
  inherit (lib) mkEnableOption mkIf;
in
{
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
      settings = {
        sunshine_name = "Emperor";
        encoder = "vaapi";
        output_name = 1;
      };
      # Add Steam big picture since in-app configuration seems to not work.
      applications = {
        env = {
          PATH = "$(PATH):$(HOME)/.local/bin";
        };
        apps = [
          {
            name = "Steam Big Picture";
            detached = [
              "setsid steam steam://open/gamepadui"
            ];
            image-path = "steam.png";
          }
        ];
      };
    };

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
  };
}
