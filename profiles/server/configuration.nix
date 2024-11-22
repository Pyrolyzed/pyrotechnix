{ config, lib, pkgs, ... }:

let
  sshKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDcpe1LanBTwdWJWHQqbgJdG48jWpg5qYpqSwenY6WCp8L0wh2yA5puRVWUKtzHMsT4L+WQCm9BF8VcLJjMJBiSHDQDH5azdzsQTP+LrQIheOXPQy3deZxEstVDcvEUvRYBnpQ2T3ISnm7EuvHIKTTVr8DdVSb9FCwoxD0OHv91XQb2Zp5dwQAe/4qWv9lxx0igH6TT6D27csi4cPXKoCvUAOfst1prL2uWQzUCy6FWEjH0CqXpt1mPR1eaExSHvt9BJKFI8WjuC8bmAKiZ1Faor9tP0r3o0Ca6MT6A6bJ933BNrTH2AFm9tawLFSdr0J26jx8Wd0/dLDob6USxMUzb1znISnsb247E3X34/ZQArb1Lq9oVjthbYbelSDUymFI4lSZsMFglfzaeSqm962keTtWCWYt6xw4Efk2BxnP8LDLAHVtpAaVXlbeRDyJoMeM9kSVL+rb0vFUJtri7o0pLBtPljQ0qJHMTiiKqzpz84ATRzJVlIoveM5AuYPZODS8= pyro";
in {
  imports =
    [ 
      ./hardware-configuration.nix
      ./disk-config.nix
    ];

  boot.loader.grub.enable = true;

  # Unsure about this in a server environment
  boot.kernelPackages = pkgs.linuxPackages_zen;

  services.tailscale = {
    enable = true;
    authKeyFile = "/home/pyro/authkey";
    extraSetFlags = [
      "--advertise-routes=192.168.1.0/24"
      "--accept-routes"
    ];
  };

  networking = {
    hostName = "homeserver-1";
    networkmanager.enable = true;
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  virtualisation.docker.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  time.timeZone = "America/Chicago"; 
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.pyro = {
    isNormalUser = true;
    extraGroups = [ "wheel" "power" "docker" ]; 
    openssh.authorizedKeys.keys = [ sshKey ];
  };

  # Allow SSH into root
  users.users.root.openssh.authorizedKeys.keys = [ sshKey ];

  environment.systemPackages = with pkgs; [
      neovim
      git

      # For clearing the terminal while in SSH
      kitty
  ];

  networking.firewall.enable = false;

  system.stateVersion = "24.05"; 
}
