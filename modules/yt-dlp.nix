_: {
  flake.homeModules.yt-dlp = _: {
    programs.yt-dlp = {
      enable = true;
      settings = {
        embed-metadata = true;
        embed-thumbnail = true;
        output = "%(title)s [%(id)s].%(ext)s";
      };
    };
  };
}
