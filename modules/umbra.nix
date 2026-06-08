{ inputs, ... }:
{
  flake.homeModules.umbra = _: {
    imports = [ inputs.umbra.homeManagerModules.default ];

    umbra = {
      enable = true;
    };
  };
}
