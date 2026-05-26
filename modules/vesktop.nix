_: {
  flake.homeModules.vesktop = { ... }: {
    programs.vesktop = {
			enable = true;
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
				enabledThemes = [ "umbra.css" ];
			};
		};
  };
}
