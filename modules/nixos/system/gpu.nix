{ config, lib, ... }:

let
  cfg = config.custom.hardware.gpu;
  inherit (lib) mkMerge mkEnableOption mkIf;
in {
  options.custom.hardware.gpu = {
    amd.enable = mkEnableOption "Enable AMD GPU drivers.";
    
    nvidia = {
      enable = mkEnableOption "Enable Nvidia GPU drivers.";
      open = mkEnableOption "Use the open source Nvidia drivers.";
      settings = mkEnableOption "Enable the Nvidia settings app.";
    };
  };

  config = (mkMerge [
    (mkIf (cfg.amd.enable && cfg.nvidia.enable) {
      assertions = [
        {
          assertion = false;
          message = "Nvidia and AMD cannot be enabled at the same time.";
        }
      ];
    })

    (mkIf cfg.amd.enable {
      boot.initrd.kernelModules = [ "amdgpu" ];
      services.xserver.videoDrivers = [ "amdgpu" ];
    })

    (mkIf cfg.nvidia.enable {
      hardware.graphics.enable = true;
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = cfg.nvidia.open;
      nvidiaSettings = cfg.nvidia.settings;
      };
    })
  ]);
}
