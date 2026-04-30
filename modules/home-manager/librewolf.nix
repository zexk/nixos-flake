{ ... }:
{
  flake.homeModules.librewolf = { ... }: {
    programs.firefox = {
      enable = true;
    };
  };
}
