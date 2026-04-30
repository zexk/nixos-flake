_:
{
  flake.homeModules.chromium =
    { pkgs, ... }:
    {
      programs.chromium = {
        enable = true;
        package = pkgs.ungoogled-chromium;
      };
    };
}
