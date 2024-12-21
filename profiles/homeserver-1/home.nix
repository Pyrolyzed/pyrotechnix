{ config, pkgs, ... }:

{
  imports = [
    ../../modules/homeManager
    ../server/home.nix
  ];

  custom = {
    scripts.enable = true;
    scripts.script.rebuild = {
      text = ''
        #!/usr/bin/env bash
	cd /home/pyro/pyrotechnix
	sudo nixos-rebuild switch --flake .#homeserver-1
      '';
      runtimeInputs = [ ];
    };
  };
}
