_: {
  flake.homeModules.direnv = _: {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
