_: {
  flake.homeModules.beets =
    { config, ... }:
    {
      programs.beets = {
        enable = true;
        mpdIntegration.enableUpdate = true;
        settings = {
          directory = "${config.home.homeDirectory}/music";
          library = "${config.xdg.dataHome}/beets/library.db";
          import = {
            move = true;
            write = true;
          };
          plugins = [
            "fetchart"
            "embedart"
          ];
        };
      };
    };
}
