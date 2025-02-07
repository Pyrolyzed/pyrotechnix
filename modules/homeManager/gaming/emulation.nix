{
  config,
  lib,
  pkgs,
  user,
  ...
}:
let
  cfg = config.custom.gaming.emulation;
  inherit (lib) mkIf mkEnableOption;
in
{
  options.custom.gaming.emulation = {
    enable = mkEnableOption "Enable emulation, emulators, and ES-DE.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      emulationstation-de
      duckstation
      flycast
      melonDS
      pcsx2
      rpcs3
      retroarchFull
      cemu
      ppsspp-qt
      dolphin-emu
    ];
  };
}
