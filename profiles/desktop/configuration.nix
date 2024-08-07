{ config, inputs, pkgs, systemSettings, userSettings, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      ../../modules/nixos
      ../../config/system.nix
      ../../modules/nixos/programs/games
    ];

  custom = {
    sound.enable = true;
    
    ssh = {
      askPass.enable = false;
      passwordAuthentication.enable = false;
      authorizedKeys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDcpe1LanBTwdWJWHQqbgJdG48jWpg5qYpqSwenY6WCp8L0wh2yA5puRVWUKtzHMsT4L+WQCm9BF8VcLJjMJBiSHDQDH5azdzsQTP+LrQIheOXPQy3deZxEstVDcvEUvRYBnpQ2T3ISnm7EuvHIKTTVr8DdVSb9FCwoxD0OHv91XQb2Zp5dwQAe/4qWv9lxx0igH6TT6D27csi4cPXKoCvUAOfst1prL2uWQzUCy6FWEjH0CqXpt1mPR1eaExSHvt9BJKFI8WjuC8bmAKiZ1Faor9tP0r3o0Ca6MT6A6bJ933BNrTH2AFm9tawLFSdr0J26jx8Wd0/dLDob6USxMUzb1znISnsb247E3X34/ZQArb1Lq9oVjthbYbelSDUymFI4lSZsMFglfzaeSqm962keTtWCWYt6xw4Efk2BxnP8LDLAHVtpAaVXlbeRDyJoMeM9kSVL+rb0vFUJtri7o0pLBtPljQ0qJHMTiiKqzpz84ATRzJVlIoveM5AuYPZODS8= pyro@PYROPC" 
      ];
    };

    network = {
      enable = true;
      hostName = systemSettings.hostname;
    };

    hardware.gpu.${systemSettings.gpuVendor}.enable = true;
    
    boot.grub = {
      enable = true;
      device = systemSettings.grubDevice;
    };

    user = {
      enable = true;
      name = userSettings.name;
    };

    locale = {
      locale = systemSettings.locale;
      timezone = systemSettings.timezone;
      keymap = "us";
    };

    desktop = {
      displayManager.${userSettings.displayManager}.enable = true;
      ${userSettings.desktopEnvironment}.enable = true;
    };

    programs = {
      games = {
        prismlauncher.enable = true;
        steam.enable = true;
        lutris.enable = true;
      };
    };
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; inherit userSettings; inherit systemSettings; };
    users = {
      ${userSettings.username} = import ./home.nix;
    };
  };

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    neovim
    kitty
  ];

  system.stateVersion = "24.05"; 
}
