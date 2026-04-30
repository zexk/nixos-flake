{ ... }:
{
  flake.homeModules.mangohud = { ... }: {
    programs.mangohud = {
      enable = true;
      settings = {
        vsync = 0;
      };
    };
  };
}
