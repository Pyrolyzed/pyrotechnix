{ lib, config, pkgs, inputs, user, ... }:
let
  inherit (lib) mkDefault;
  sshKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDcpe1LanBTwdWJWHQqbgJdG48jWpg5qYpqSwenY6WCp8L0wh2yA5puRVWUKtzHMsT4L+WQCm9BF8VcLJjMJBiSHDQDH5azdzsQTP+LrQIheOXPQy3deZxEstVDcvEUvRYBnpQ2T3ISnm7EuvHIKTTVr8DdVSb9FCwoxD0OHv91XQb2Zp5dwQAe/4qWv9lxx0igH6TT6D27csi4cPXKoCvUAOfst1prL2uWQzUCy6FWEjH0CqXpt1mPR1eaExSHvt9BJKFI8WjuC8bmAKiZ1Faor9tP0r3o0Ca6MT6A6bJ933BNrTH2AFm9tawLFSdr0J26jx8Wd0/dLDob6USxMUzb1znISnsb247E3X34/ZQArb1Lq9oVjthbYbelSDUymFI4lSZsMFglfzaeSqm962keTtWCWYt6xw4Efk2BxnP8LDLAHVtpAaVXlbeRDyJoMeM9kSVL+rb0vFUJtri7o0pLBtPljQ0qJHMTiiKqzpz84ATRzJVlIoveM5AuYPZODS8= pyro";
in {
  imports = [
    ../../modules/nixos
  ];
  nix.settings = {
    experimental-features = [ 
      "nix-command" 
      "flakes"
      "pipe-operators"
    ];
    trusted-users = [ user ];
  };
  time.timeZone = mkDefault "America/Chicago";
  i18n.defaultLocale = mkDefault "en_US.UTF-8";
  services.openssh = {
    enable = mkDefault true;
    settings = {
      PasswordAuthentication = mkDefault false;
      KbdInteractiveAuthentication = mkDefault false;
    };
  };

  boot.kernelPackages = mkDefault pkgs.linuxPackages_zen;

  # Set Pi-hole as default DNS with Cloudflare backup
  networking.nameservers = mkDefault [ 
    "192.168.1.132"
    "1.1.1.1"
  ];

  systemd = {
    services = {
      NetworkManager-wait-online.enable = false;
    };
    extraConfig = ''
      DefaultTimeoutStopSec=5s
    '';
  };

  users.users.${user} = {
    openssh.authorizedKeys.keys = mkDefault [ sshKey ];
  };

  # Allow SSH into root for nixos-install-anywhere
  users.users.root.openssh.authorizedKeys.keys = mkDefault [ sshKey ];

  networking.firewall.enable = mkDefault false;

  system.stateVersion = "24.05";
}
