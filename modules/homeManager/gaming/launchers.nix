{ config, osConfig, lib, pkgs, user, ... }:
let
  cfg = config.custom.gaming.launchers;
  inherit (lib) mkIf mkEnableOption mkMerge;
  createLauncherConfig = pkg: setting: { 
    home.packages = mkIf cfg.${setting}.enable [ pkg ]; 
  };
in {
  options.custom.gaming.launchers = { 
    lutris.enable = mkEnableOption "Enable Lutris." // { default = osConfig.custom.gaming.enable; };
    prismlauncher.enable = mkEnableOption "Enable Prism Launcher." // { default = osConfig.custom.gaming.enable; };
  };

  config = (mkMerge [
    (createLauncherConfig pkgs.lutris "lutris")
    (createLauncherConfig pkgs.prismlauncher "prismlauncher")
  ]);
}
