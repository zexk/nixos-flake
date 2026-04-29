{ pkgs, ... }:
let
  dmenu = pkgs.dmenu.overrideAttrs ({
    src = [ ../../pkgs/dmenu/. ];
    preConfigure = ''
        makeFlagsArray+=(
          PREFIX="$out"
          CC="$CC -lm"
          # default config.mk hardcodes dependent libraries and include paths
        #INCS="`$PKG_CONFIG --cflags fontconfig x11 xft xinerama`"
        #  LIBS="`$PKG_CONFIG --libs fontconfig x11 xft xinerama`"
      )'';
  });
in
{
  home.packages = [
    dmenu
    (pkgs.writeshellapplication {
      name = "dmenu_pass";
      text = builtins.readfile ./passmenu2;
    })
    (pkgs.writeShellApplication {
      name = "dmenu_mpd";
      text = builtins.readFile ./mpd;
    })
    (pkgs.writeShellApplication {
      name = "dmenu_quit";
      text = builtins.readFile ./quit;
    })
    (pkgs.writeShellApplication {
      name = "dmenu_kill";
      text = builtins.readFile ./kill;
    })
  ];
}
