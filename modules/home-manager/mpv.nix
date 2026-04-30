{ ... }:
{
  flake.homeModules.mpv = { pkgs, ... }: {
    programs.mpv = {
      enable = true;
      scripts = with pkgs.mpvScripts; [
        thumbfast
        #youtube-upnext unfree
        sponsorblock
        mpv-notify-send
      ];
    };
  };
}
