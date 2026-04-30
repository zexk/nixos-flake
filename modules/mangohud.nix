_:
{
  flake.homeModules.mangohud =
    _:
    {
      programs.mangohud = {
        enable = true;
        settings = {
          vsync = 0;
        };
      };
    };
}
