_: {
  flake.nixosModules.xdg =
    { pkgs, ... }:
    {
      xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
        config.common.default = "*";
        xdgOpenUsePortal = true;
      };
    };

  flake.homeModules.xdg = _: {
    xdg.userDirs = {
      enable = true;
      setSessionVariables = false;
      createDirectories = true;
      desktop = "$HOME/desktop";
      documents = "$HOME/documents";
      download = "$HOME/downloads";
      music = "$HOME/music";
      pictures = "$HOME/pictures";
      videos = "$HOME/videos";
      publicShare = "$HOME/public";
      templates = "$HOME/templates";
      projects = "$HOME/projects";
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "ungoogled-chromium.desktop";
        "x-scheme-handler/http" = "ungoogled-chromium.desktop";
        "x-scheme-handler/https" = "ungoogled-chromium.desktop";
        "x-scheme-handler/about" = "ungoogled-chromium.desktop";
        "x-scheme-handler/unknown" = "ungoogled-chromium.desktop";
        "application/xhtml+xml" = "ungoogled-chromium.desktop";
        "application/pdf" = "sioyek.desktop";
        "image/png" = "feh.desktop";
        "image/jpeg" = "feh.desktop";
        "image/gif" = "feh.desktop";
        "image/webp" = "feh.desktop";
        "image/bmp" = "feh.desktop";
        "image/tiff" = "feh.desktop";
        "image/svg+xml" = "feh.desktop";
        "video/mp4" = "mpv.desktop";
        "video/webm" = "mpv.desktop";
        "video/ogg" = "mpv.desktop";
        "video/x-msvideo" = "mpv.desktop";
        "video/x-matroska" = "mpv.desktop";
        "video/quicktime" = "mpv.desktop";
        "audio/mpeg" = "mpv.desktop";
        "audio/ogg" = "mpv.desktop";
        "audio/flac" = "mpv.desktop";
        "audio/x-wav" = "mpv.desktop";
        "audio/x-flac" = "mpv.desktop";
        "audio/x-mpegurl" = "mpv.desktop";
        "application/x-bittorrent" = "transmission-gtk.desktop";
        "text/plain" = "nvim.desktop";
        "image/x-xcf" = "drawy.desktop";
        "application/x-krita" = "drawy.desktop";
      };
    };
  };
}
