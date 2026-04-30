_:
{
  flake.homeModules.zoxide =
    _:
    {
      programs.zoxide = {
        enable = true;
        enableBashIntegration = true;
        options = [ "--cmd cd" ];
      };
    };
}
