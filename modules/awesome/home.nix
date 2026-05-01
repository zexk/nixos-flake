_: {
  flake.homeModules.awesome = _: {
    xsession.windowManager.awesome = {
      enable = true;
      noArgb = true;
    };

    home.file."background-image" = {
      enable = true;
      source = ./background-image;
    };

    home.file.".config/awesome/rc.lua" = {
      enable = true;
      source = ./rc.lua;
    };

    home.file.".config/awesome/theme.lua" = {
      enable = true;
      source = ./theme.lua;
    };
  };
}
