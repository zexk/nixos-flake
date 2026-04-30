_:
{
  flake.homeModules.git =
    _:
    {
      programs = {
        git = {
          enable = true;
          signing.format = null;
          settings = {
            user = {
              name = "Bouraoui Ochi";
              email = "bouraoui@outlook.it";
            };
            init = {
              defaultBranch = "master";
            };
          };
        };
        gh = {
          enable = true;
        };
        lazygit = {
          enable = true;
        };
      };
    };
}
