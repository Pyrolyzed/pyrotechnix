{ config, lib, pkgs, ... }:
{  
  networking = {
    useDHCP = false;
    interfaces.ens18 = {
      wakeOnLan = {
        enable = true;
        policy = [ "magic" ];
      };
    };
    defaultGateway = {
      address = "192.168.1.1";
      interface = "ens18";
    };
  };

  programs.tmux.enable = true;
  environment.systemPackages = with pkgs; [
    neovim
    git
    unrar
    unzip

    # For clearing the terminal while in SSH
    kitty
  ];
}
