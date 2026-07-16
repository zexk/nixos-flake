_: {
  flake.homeModules.vesktop = _: {
    programs.vesktop = {
      enable = true;
      settings = {
        appBadge = false;
        arRPC = true;
        checkUpdates = false;
        customTitleBar = false;
        disableMinSize = true;
        minimizeToTray = false;
        tray = false;
        splashBackground = "#000000";
        splashColor = "#ffffff";
        splashTheming = true;
        staticTitle = true;
        hardwareAcceleration = true;
        discordBranch = "stable";
      };
      vencord = {
        useSystem = true;
        settings = {
          autoUpdate = false;
          autoUpdateNotification = false;
          disableMinSize = true;
          notifyAboutUpdates = false;
          plugins = {
            FakeNitro = {
              enabled = true;
            };
          };
          useQuickCss = true;
          enabledThemes = [ "Umbra" ];
        };
      };
    };
  };
}
