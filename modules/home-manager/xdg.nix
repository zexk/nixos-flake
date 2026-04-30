{ ... }:
{
  flake.homeModules.xdg = { ... }: {
    xdg.mime = {
      enable = true;
    };
  };
}
