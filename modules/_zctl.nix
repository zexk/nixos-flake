{ inputs, ... }:
{
  flake.nixosModules.zctl = {
    imports = [ inputs.zctl.nixosModules.zctl ];
  };
}
