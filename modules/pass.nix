{ ... }:
{
  flake.homeModules.pass = { ... }: {
    programs.password-store = {
      enable = true;
      settings = { };
    };
  };
}
