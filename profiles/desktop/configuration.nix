{ config, inputs, pkgs, ... }:

let
  username = "pyro";
  hostname = "nixos";

  desktopEnvironment = "gnome";
  displayManager = "gdm";
in {
  imports =
    [ 
      ./hardware-configuration.nix
      ../../modules/nixos/system
      ../../modules/nixos/desktop
    ];

  custom = {
    sound.enable = true;
    network.enable = true;
    # hardware.gpu.amd.enable = true;
    
    boot.grub = {
      enable = true;
      device = "/dev/vda";
    };

    user = {
      enable = true;
      name = "pyro";
    };

    locale = {
      locale = "en_US.UTF-8";
      timezone = "America/Chicago";
      keymap = "us";
    };

    desktop = {
      displayManager.${displayManager}.enable = true;
      ${desktopEnvironment}.enable = true;
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
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    kitty
  ];

  networking.firewall.enable = false;

  system.stateVersion = "24.05"; 
}
