_: {
  flake.homeModules.firefox = _: {
    programs.firefox = {
      enable = true;
      configPath = ".mozilla/firefox";
    };
  };
}
