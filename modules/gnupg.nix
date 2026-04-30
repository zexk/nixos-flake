_:
{
  flake.nixosModules.gnupg =
    { pkgs, ... }:
    {
      programs.gnupg = {
        agent = {
          enable = true;
          enableBrowserSocket = true;
          enableSSHSupport = true;
          pinentryPackage = pkgs.pinentry-dmenu;
        };
      };
    };
}
