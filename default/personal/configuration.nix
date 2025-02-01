{ config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nixfmt-rfc-style
  ];
}
