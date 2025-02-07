{ config, lib, pkgs, user, ... }:
let
  cfg = config.custom.gaming.games;
  inherit (lib) mkIf mkEnableOption mkMerge;
  createGameConfig = pkg: setting: { 
    home.packages = mkIf cfg.${setting}.enable [ pkg ]; 
  };

  # Patch to add EF CDLC
  arma3-unix-launcher = pkgs.arma3-unix-launcher.overrideAttrs (old: {
    patches = (old.patches or []) ++ [
      ../../../patches/a3unix.patch
    ];
  });
in {
  options.custom.gaming.games = {
    armaLauncher.enable = mkEnableOption "Enable the Arma 3 Unix Launcher";
    cloneHero.enable = mkEnableOption "Enable Clone Hero";
  };

  config = (mkMerge [
    (createGameConfig arma3-unix-launcher "armaLauncher")
    (createGameConfig pkgs.clonehero "cloneHero")
  ]);
}
