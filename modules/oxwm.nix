{ ... }:
{
  flake.nixosModules.oxwm = { inputs, pkgs, ... }: {
    services.xserver.windowManager.oxwm = {
      enable = true;
      package = inputs.oxwm.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };
  };
}
