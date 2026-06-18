_: {
  flake.homeModules.mpv =
    { pkgs, config, ... }:
    {
      programs.mpv = {
        enable = true;
        scripts = with pkgs.mpvScripts; [
          thumbfast
          sponsorblock
          mpv-notify-send
        ];

        config = {
          # Video
          vo = "gpu-next";
          gpu-context = "x11";
          hwdec = "auto-safe";
          scale = "ewa_lanczossharp";
          cscale = "lanczos";
          deband = true;
          correct-downscaling = true;
          dither-depth = "auto";

          # Audio
          volume = 70;
          volume-max = 130;
          volume-normalize = true;

          # General
          save-position-on-quit = true;
          keep-open = true;
          keepaspect-window = true;
          cache-default = 150000;

          # OSD
          osd-font = "Tessera Mono";
          osd-font-size = 32;

          # Screenshots
          screenshot-format = "png";
          screenshot-directory = "${config.xdg.userDirs.pictures}/screenshots/mpv";
          screenshot-high-bit-depth = true;
        };
      };
    };
}
