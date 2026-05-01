_: {
  flake.nixosModules.mouse = _: {
    services.libinput = {
      enable = true;
      mouse.accelProfile = "flat";
    };
  };
}
