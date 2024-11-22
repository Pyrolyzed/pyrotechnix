{ pkgs, lib, config, ... }:
let
  inherit (lib) mkOption mkEnableOption mkIf;
  inherit (lib.types) str attrsOf listOf submodule;
  cfg = config.custom.scripts;
in {
  options.custom.scripts = {
    enable = mkEnableOption "Enable script configuration.";
    script = mkOption {
      type = attrsOf (submodule {
        options = {
	  text = mkOption {
	    type = str;
	    description = "The script commands";
	  };
	  runtimeInputs = mkOption {
	    type = listOf str;
	    description = "Packages used in the script";
	  };
	};
      });
      description = "User defined scripts";
      default = { };
    };
  };

  config = mkIf cfg.enable {
    home.packages = lib.mapAttrsToList (
      name: value: pkgs.writeShellApplication (value // { inherit name; })
    ) cfg.script;
  };
}
