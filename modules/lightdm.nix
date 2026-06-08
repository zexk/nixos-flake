_: {
  flake.nixosModules.lightdm =
    { pkgs, ... }:
    {
      services.xserver.displayManager.lightdm = {
        enable = true;
        greeters.gtk = {
          enable = true;
        };
      };
    };
}
