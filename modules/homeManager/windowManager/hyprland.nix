{ config, lib, pkgs, ... }:
let
  cfg = config.custom.windowManager.hyprland;
  inherit (lib) mkOption mkEnableOption types mkIf;
in {
  options.custom.windowManager.hyprland = {
    enable = mkEnableOption "Enable hyprland";
    monitors = mkOption {
      type = types.listOf (types.submodule {
        options = {
	  name = mkOption {
	    type = types.str;
	    example = "DP-1";
	  };
	  enabled = mkEnableOption "Enable monitor" // { default = true; };
	  width = mkOption {
	    type = types.int;
	    example = 1920;
	  };
	  height = mkOption {
	    type = types.int;
	    example = 1080;
	  };
	  refreshRate = mkOption {
	    type = types.int;
	    example = 60;
	  };
	  x = mkOption {
	    type = types.int;
	    example = 0;
	  };
	  y = mkOption {
	    type = types.int;
	    example = 0;
	  };
	  scale = mkOption {
	    type = types.float;
	    example = 1;
	  };
	};
      });
      default = [ ];
    };
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
    };
  };
}
