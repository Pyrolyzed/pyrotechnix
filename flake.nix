{
  description = "Pyrotechnix Flake.";

  outputs = { self, nixpkgs, ...}@inputs: 
    let
      # FLAKE SETTINGS
      systemSettings = {
        profile = "homeserver";
        system = "x86_64-linux";
        hostname = "homeserver0";
        timezone = "America/Chicago";
        locale = "en_US.UTF-8";
        grubDevice = "nodev";
        gpuVendor = "amd";
        dnsServer = "192.168.1.100";
      };

      userSettings = {
        username = "pyro";
        name = "Pyro";
        email = "pyrolyzed@proton.me";
      };

    in {
      nixosConfigurations.system = nixpkgs.lib.nixosSystem {
      system = systemSettings.system;
      specialArgs = {
        inherit inputs; 
        inherit systemSettings;
        inherit userSettings;
      };
      modules = [
        ./profiles/${systemSettings.profile}/configuration.nix

        inputs.home-manager.nixosModules.default
      ];
    };
  };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
