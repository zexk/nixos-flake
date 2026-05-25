_: {
  flake.homeModules.dmenu =
    { pkgs, ... }:
    let
      dmenu = pkgs.callPackage ../../pkgs/dmenu { };
    in
    {
      home.packages = [
        dmenu

        (pkgs.writeShellApplication {
          name = "dmenu-test";
          runtimeInputs = [ dmenu ];
          text = ''
            printf 'foo\nbar\nbaz\n' | dmenu "$@"
          '';
        })

        (pkgs.writeShellApplication {
          name = "dmenu_pass";
          text = builtins.readFile ../_dmenu/passmenu2;
        })
        (pkgs.writeShellApplication {
          name = "dmenu_mpd";
          text = builtins.readFile ../_dmenu/mpd;
        })
        (pkgs.writeShellApplication {
          name = "dmenu_quit";
          text = builtins.readFile ../_dmenu/quit;
        })
        (pkgs.writeShellApplication {
          name = "dmenu_kill";
          text = builtins.readFile ../_dmenu/kill;
        })
      ];
    };
}
