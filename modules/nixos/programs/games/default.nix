{ pkgs, config, ... }:
{
    imports = [
        "./steam.nix"
        "./prismlauncher.nix"
        "./lutris.nix"
    ];

    environment.systemPackages = with pkgs; [
        protonup-qt
        protontricks
    ]
}