_:
{
  flake.homeModules.direnv =
    _:
    {
      programs.direnv = {
        enable = true;
        enableBashIntegration = true;
        nix-direnv.enable = true;
      };
    };
}
