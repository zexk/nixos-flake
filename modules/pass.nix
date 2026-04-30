_:
{
  flake.homeModules.pass =
    _:
    {
      programs.password-store = {
        enable = true;
        settings = { };
      };
    };
}
