{ config, inputs, pkgs, ... }:

let
  username = "pyro";
  hostname = "nixos";
in {
  imports =
    [ 
      ./hardware-configuration.nix
      ./disko.nix

      ../../modules/nixos/system
      ../../modules/nixos/desktop
    ];

  custom = {
    sound.enable = true;
    network = {
      enable = true;
      hostName = hostname;
    };
    # hardware.gpu.amd.enable = true;
    
    boot.grub = {
      enable = true;
      device = "/dev/vda";
    };

    user = {
      enable = true;
      name = username;
    };

    locale = {
      locale = "en_US.UTF-8";
      timezone = "America/Chicago";
      keymap = "us";
    };

    desktop = {
      displayManager.gdm.enable = true;
      gnome = {
        enable = true;
	tweaks.enable = true;
      };
    };
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      ${username} = import ./home.nix;
    };
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Install firefox.
  programs.firefox.enable = true;

  services.openssh.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    neovim
    kitty
  ];

  networking.firewall.enable = false;

  system.stateVersion = "24.05"; 
}
