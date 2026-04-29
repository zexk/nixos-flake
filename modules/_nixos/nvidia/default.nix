{
  config,
  lib,
  ...
}:
{
  options = {
    modules.nvidiaGpu.enable = lib.mkEnableOption "enable custom NVIDIA gpu settings";
  };

  config = lib.mkIf config.modules.nvidiaGpu.enable {
    allowedUnfree = [
      "nvidia-x11"
      "nvidia-settings"
    ];

    hardware = {
      nvidia = {
        open = true;
        package = config.boot.kernelPackages.nvidiaPackages.beta;
        nvidiaSettings = false;
        modesetting.enable = true;
        gsp.enable = true;
        powerManagement = {
          enable = false;
          finegrained = false;
        };
      };
    };
    services.xserver.videoDrivers = [ "nvidia" ];
  };
}
