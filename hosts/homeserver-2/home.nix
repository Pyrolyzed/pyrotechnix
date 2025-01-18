{ config, pkgs, ... }:

{
  imports = [
    ../../modules/homeManager
  ];

  custom = {
    scripts.enable = true;
    scripts.script.rebuild = {
      text = ''
        #!/usr/bin/env bash
	cd /home/pyro/pyrotechnix
	sudo nixos-rebuild switch --flake .#homeserver-2
      '';
      runtimeInputs = [ ];
    };
  };
}
