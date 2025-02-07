{
  config,
  lib,
  pkgs,
  host,
  ...
}:
let
  projectDir = "/home/pyro/Projects/pyrotechnix";
  servers = {
    "1" = "192.168.1.151";
    "4" = "192.168.1.147";
  };
in
{
  custom = {
    scripts = {
      enable = true;
      script = {
        rebuild = {
          text = ''
            	    #!/usr/bin/env bash
            	    cd ${projectDir}
            	    if [ $# -eq 0 ]; then
            	      sudo nixos-rebuild switch --flake .#${host}
            	    elif [[ $1 == "boot" ]]; then
            	      sudo nixos-rebuild boot --flake .#${host}
            	    fi
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
          text =
            ''
              	    #!/usr/bin/env bash
              	  ''
            + lib.strings.concatLines (lib.mapAttrsToList (id: ip: "rebuild-server ${id} ${ip}") servers);
        };

        get-new-files = {
          text = ''
            	    #!/usr/bin/env bash
            	    sudo fd --one-file-system --base-directory / --type f --hidden --exclude "{tmp,etc/passwd}"
            	  '';
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
  };
}
