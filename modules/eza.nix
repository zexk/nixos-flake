_: {
  flake.homeModules.eza = _: {
    programs.eza = {
      enable = true;
      colors = "always";
      git = true;
      extraOptions = [
        "--group-directories-first"
        "--header"
      ];
    };
  };
}
