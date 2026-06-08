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
      ];
    };
}
