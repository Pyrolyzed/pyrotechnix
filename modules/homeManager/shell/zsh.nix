{ lib, pkgs, config, ... }:
let
  inherit (lib) mkOption mkEnableOption mkIf optionalString;
  inherit (lib.types) str listOf attrsOf;
  cfg = config.custom.shell.zsh;
in {
  options.custom.shell.zsh = {
    enable = mkEnableOption "Enable ZSH";
    aliases = mkOption {
      type = attrsOf str;
      default = { };
      description = "Shell aliases";
    };
    options = {
      extendedGlobbing = mkEnableOption "Enable extending globbing";
      ignoreDups = mkEnableOption "Ignore duplicate commands";
      ignoreAllDups = mkEnableOption "Ignore ALL duplicate commands";
    };
    
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;

      history = {
        path = "$HOME/.zsh_history";
	save = 10000;
	share = true;
	size = 10000;
        ignoreAllDups = cfg.options.ignoreAllDups;
	ignoreDups = cfg.options.ignoreDups;
      };

      historySubstringSearch.enable = true;

      shellAliases = {
        # Anything here
      } // cfg.aliases;

      initExtra = optionalString cfg.options.extendedGlobbing ''
        setopt extended_glob
      '';
      # repeat with "+ optionalString secondOptionName" for more options
      

    };

  };
}
