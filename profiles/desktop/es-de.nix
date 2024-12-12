self: super: {
  es-de = super.es-de.overrideAttrs (oldAttrs: rec {
    postPatch = oldAttrs.postPatch or "" + ''
      sed -i 's/Ryujinx (Standalone)">%EMULATOR_RYUJINX/Yuzu">%EMULATOR_YUZU' share/es-de/resources/systems/linux/es_systems.xml
      sed -i 's/name="RYUJINX"/name="YUZU"' /share/es-de/resources/systems/linux/es_find_rules.xml
      sed -i 's#~/Applications/publish/Ryujinx#~/Storage/Emulation/Emulators/Yuzu' /share/es-de/resources/systems/linux/es_find_rules.xml
      sed -i 's/<entry>Ryujinx</<entry>yuzu<' /share/es-de/resources/systems/linux/es_find_rules.xml
    '';
  });
}
