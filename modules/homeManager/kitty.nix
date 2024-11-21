{ lib, pkgs, config, ... }:
let
  inherit (lib) mkOption mkEnableOption mkIf;
  inherit (lib.types) str float int;
  cfg = config.custom.kitty;
in {
  options.custom.kitty = {
    enable = mkEnableOption "Enable kitty configuration";
    backgroundOpacity = mkOption {
      type = float;
      description = "Background opacity of Kitty window";
      default = 1.0;
    };
    font = mkOption {
      type = str;
      description = "Font family of Kitty";
      default = "Monospace";
    };
    fontSize = mkOption {
      type = int;
      description = "Font size of Kitty";
      default = 14;
    };
    warnOnClose = mkEnableOption "Enable kitty warning you on closing it";
  };

  config = mkIf cfg.enable {
    programs.kitty.enable = true;
    programs.kitty.font.name = cfg.font;
    programs.kitty.font.size = cfg.fontSize;
    programs.kitty.settings = {
      background_opacity = cfg.backgroundOpacity;
      confirm_os_window_close = if cfg.warnOnClose then 1 else 0;
    };
  };
}
