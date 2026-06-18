_: {
  flake.homeModules.browserpass = _: {
    programs.browserpass = {
      enable = true;
      browsers = [
        "chromium"
        "firefox"
      ];
    };
  };
}
