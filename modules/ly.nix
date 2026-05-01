_: {
  flake.nixosModules.ly = _: {
    services.displayManager.ly = {
      enable = true;
      x11Support = true;
      settings = { };
    };
  };
}
