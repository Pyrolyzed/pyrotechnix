{ config, osConfig, lib, pkgs, user, ... }:
let
  cfg = config.custom.gaming.utilities;
  settingsType = with lib.types; (oneOf [ bool int float str path (listOf (oneOf [ int str ])) ]);
  inherit (lib) mkIf mkEnableOption mkOption;
  inherit (lib.types) attrsOf;
in {
  options.custom.gaming = {
    utilities = {
      enable = mkEnableOption "Enable common gaming utilities such as ProtonUp and Mangohud" // { default = osConfig.custom.gaming.enable; };
      mangohud.settings = mkOption {
        type = attrsOf settingsType;
	default = {
	  gpu_stats = true;
	  gpu_temp = true;
	  gpu_core_clock = true;
	  gpu_mem_clock = true;
	  gpu_power = true;
	  cpu_stats = true;
	  cpu_temp = true;
	  cpu_mhz = true;
	  cpu_power = true;
	  vram = true;
	  ram = true;
	  fps = true;
	  frametime = true;
	  throttling_status = true;
	  gpu_name = true;
	  frame_timing = true;
	  font_size = 36;
	  font_size_text = 36;
	  text_outline = true;
	  toggle_hud = "Shift_R+F12";
	};
	description = "MangoHud Configuration";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      protonup-qt
      gamescope
      steamtinkerlaunch
      protontricks
    ];

    programs.mangohud = {
      enable = true;
      settings = cfg.mangohud.settings;
    };
  };
}
