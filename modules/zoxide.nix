_: {
  flake.homeModules.zoxide = _: {
    programs.zoxide = {
      enable = true;
      options = [ "--cmd cd" ];
    };
  };
}
