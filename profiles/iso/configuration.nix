{ pkgs, lib, config, modulesPath, ... }: 
{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.networkmanager.enable = true;
  networking.wireless.enable = false;
  environment.systemPackages = with pkgs; [
    neovim
    disko
    git
    parted
    kitty
    firefox
  ];

  services = {
    xserver = {
      enable = true;
      desktopManager.cinnamon.enable = true;
      displayManager.lightdm.enable = true;
    };
    cinnamon.apps.enable = true;
    openssh.enable = true;
  };
}
