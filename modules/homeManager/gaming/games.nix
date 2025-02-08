{
  config,
  lib,
  pkgs,
  user,
  ...
}:
let
  cfg = config.custom.gaming.games;
  inherit (lib) mkIf mkEnableOption mkMerge;
  createGameConfig = pkg: setting: {
    home.packages = mkIf cfg.${setting}.enable [ pkg ];
  };

  # Patch to add EF CDLC
  arma3-unix-launcher = pkgs.arma3-unix-launcher.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      (pkgs.fetchpatch {
        url = "https://github.com/DrymarchonShaun/arma3-unix-launcher/commit/9e8b274443bebccd3b3e4a261bca9ddc2d508c72.patch";
        hash = "sha256-0swtiB9g/8nU3ws63SvFVVgFhPwlwjZcn7F1aYHyKhc=";
      })
      (pkgs.fetchpatch {
        url = "https://github.com/Pyrolyzed/arma3-unix-launcher/commit/76dabcb69d1ddddd50a27afb29cd7351f65b539b.patch";
	hash = "sha256-CD2SwCZYP79JH9M/6HCvesGYBCaqHWwhMUXtzskXrUE=";
      })
    ];
  });
in
{
  options.custom.gaming.games = {
    armaLauncher.enable = mkEnableOption "Enable the Arma 3 Unix Launcher";
    cloneHero.enable = mkEnableOption "Enable Clone Hero";
  };

  config = (
    mkMerge [
      (createGameConfig arma3-unix-launcher "armaLauncher")
      (createGameConfig pkgs.clonehero "cloneHero")
    ]
  );
}
