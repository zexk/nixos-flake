{ ... }:
{
  flake.nixosModules.awesome = { inputs, pkgs, ... }: {
    services.xserver.windowManager.oxwm = {
      enable = true;
      package = inputs.oxwm.packages.${pkgs.system}.default;
    };
  };
}
