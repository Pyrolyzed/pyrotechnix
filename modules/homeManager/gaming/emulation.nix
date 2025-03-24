{
  config,
  lib,
  pkgs,
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
    home = {
      file.".config/ES-DE/custom_systems/es_find_rules.xml" = {
        text = ''
          <?xml version="1.0"?>
          <ruleList>
            <emulator name="CITRON">
              <rule type="staticpath">
                <entry>~/.local/share/citron</entry>
              </rule>
            </emulator>
            <core name="RETROARCH">
              <rule type="corepath">
                <entry>${pkgs.retroarchFull}/lib/retroarch/cores</entry>
              </rule>
            </core>
          </ruleList>
        '';
      };
      file.".config/ES-DE/custom_systems/es_systems.xml" = {
        text = ''
          <?xml version="1.0"?>
          <systemList>
            <system>
              <name>switch</name>
              <fullname>Nintendo Switch</fullname>
              <path>%ROMPATH%/switch</path>
              <extension>.nca .NCA .nro .NRO .nso .NSO .nsp .NSP .xci .XCI</extension>
              <command label="Citron">citron %ROM%</command>
              <platform>switch</platform>
              <theme>switch</theme>
            </system>
          </systemList>
        '';
      };
      packages = with pkgs; [
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
  };
}
