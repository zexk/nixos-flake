_: {
  flake.nixosModules.zram = _: {
    zramSwap = {
      enable = true;
      algorithm = "zstd";
    };

    systemd.oomd = {
      enable = true;
      enableRootSlice = true;
      enableSystemSlice = true; # llama-cpp runs in system.slice
      enableUserSlices = true;
    };
  };
}
