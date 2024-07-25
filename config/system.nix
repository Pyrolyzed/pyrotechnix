{ config, inputs, pkgs, ... }:

{
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    services.printing.enable = true;
    nixpkgs.config.allowUnfree = true;
}