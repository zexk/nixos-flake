{ pkgs, ... }:
{
  services = {
    xserver.windowManager.dwm = {
      enable = true;
      package = pkgs.dwm.overrideAttrs (oldAttrs: {
        src = ../../pkgs/dwm/.;
        buildInputs = with pkgs.xorg; [
          libX11
          libXinerama
          libXft
          libXres
        ];
      });
      extraSessionCommands = "sxhkd &";
    };

    dwm-status = {
      enable = true;
      settings = {
        order = [ "time" ];
        time = {
          format = "%F %A %X";
          update_seconds = true;
        };
      };
    };
  };
}
