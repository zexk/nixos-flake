{ ... }:
{
  flake.homeModules.qt = { ... }: {
    qt = {
      enable = true;
      style.name = "kvantum";
    };
  };
}
