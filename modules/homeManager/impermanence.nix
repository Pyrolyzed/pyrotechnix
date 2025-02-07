{
  config,
  lib,
  pkgs,
  inputs,
  user,
  ...
}:
let
  cfg = config.custom.impermanence;
  inherit (lib) mkEnableOption mkIf;
in
{
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];
  options.custom.impermanence = {
    enable = mkEnableOption "Enable impermanence";
  };

  config = mkIf cfg.enable {
    home.persistence."/persist/home/${user}" = {
      allowOther = true;
    };
  };
}
