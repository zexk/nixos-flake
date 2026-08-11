_: {
  flake.homeModules.fd = _: {
    programs.fd = {
      enable = true;
      hidden = true;
      ignores = [ ".git/" ];
    };
  };
}
