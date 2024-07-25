{ config, lib, pkgs, ... }:
let
  cfg = config.custom.programs.browser;
  inherit (lib) mkEnableOption mkIf mkMerge;
in {
    options.custom.programs.browser = {
        firefox.enable = mkEnableOption "Enable the Firefox browser.";
        librewolf.enable = mkEnableOption "Enable the Librewolf browser.";
        chromium.enable = mkEnableOption "Enable the Chromium browser.";
    };

    config = {
        programs.firefox.enable = cfg.firefox.enable;
        programs.librewolf.enable = cfg.librewolf.enable;
        programs.chromium.enable = cfg.chromium.enable;
    };
}