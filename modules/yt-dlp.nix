_: {
  flake.homeModules.yt-dlp =
    { pkgs, ... }:
    {
      programs.yt-dlp = {
        enable = true;
        settings = {
          embed-metadata = true;
          embed-thumbnail = true;
          output = "%(title)s [%(id)s].%(ext)s";
        };
      };

      home.packages = [ pkgs.ytfzf ];
    };
}
