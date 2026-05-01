_: {
  flake.homeModules.librewolf = _: {
    programs.firefox = {
      enable = true;
    };
  };
}
