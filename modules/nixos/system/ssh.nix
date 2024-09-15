{ config, lib, ... }:
let
  cfg = config.custom.ssh;
  inherit (lib) mkEnableOption mkIf mkMerge mkOption;
  inherit (lib.types) listOf str;
in {
    options.custom.ssh = {
        enable = mkEnableOption "Enable SSH." // { default = true; };
        askPass.enable = mkEnableOption "Enable SSH AskPass.";
        passwordAuthentication.enable = mkEnableOption "Enable password authentication";
        authorizedKeys = mkOption {
            type = listOf str;
            default = [];
            description = "List of authorized public keys.";
        };
    };

    config = {
        services.openssh.enable = cfg.enable;
        services.openssh.settings = {
            PermitRootLogin = "no";
            PasswordAuthentication = cfg.passwordAuthentication.enable;
        };
        programs.ssh.enableAskPassword = cfg.askPass.enable;
        users.users.${lib.toLower config.custom.user.name}.openssh.authorizedKeys.keys = cfg.authorizedKeys;
    };
}
