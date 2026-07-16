_: {
  flake.nixosModules.amd = _: {
    hardware = {
      amdgpu = {
        opencl.enable = true;
        initrd.enable = true;
      };
      graphics = {
        enable = true;
        enable32Bit = true;
      };
    };

    services.xserver.videoDrivers = [ "amdgpu" ];
  };
}
