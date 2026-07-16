{ inputs, ... }:
{
  flake.homeModules.wstudio = _: {
    imports = [ inputs.wstudio.homeManagerModules.default ];

    programs.wstudio.enable = true;
  };
}
