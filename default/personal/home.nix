{ config, lib, pkgs, host, ... }:
let
  projectDir = "/home/pyro/Projects/pyrotechnix";
  servers = {
    "1" = "192.168.1.151";
    "4" = "192.168.1.147";
  };
in {
  scripts = {
    enable = true;
    script = {
      rebuild = {
	text = ''
	  #!/usr/bin/env bash
	  cd ${projectDir}
	  sudo nixos-rebuild switch --flake .#${host}
	'';
      };

      rebuild-server = {
	text = ''
	  #!/usr/bin/env bash
	  cd ${projectDir}
	  build_server () {
	    num=$1
	    ip=$2

	    echo "Rebuilding homeserver-$num..."
	    nixos-rebuild switch --flake .#homeserver-"$num" --target-host root@"$ip" > ${projectDir}/.logs/homeserver-"$num"-build.log
	    echo "Done."
	  }
	  build_server "$1" "$2"
	'';
      };
      rebuild-servers = {
	text = ''
	  #!/usr/bin/env bash
	'' + lib.mapAttrs (id: ip: "rebuild-server ${id} ${ip}") servers;
      };

      install-remote = {
	text = ''
	  #!/usr/bin/env bash
	  cd ${projectDir}
	  flake=$1
	  host=$2
	  nix run github:nix-community/nixos-anywhere -- --flake .#"$flake" root@"$host"
	'';
      };
      build-iso = {
	text = ''
	  #!/usr/bin/env bash
	  cd ${projectDir}
	  nix build .#nixosConfigurations.isoInstaller.config.system.build.isoImage
	'';
      };
    };
  };
}
