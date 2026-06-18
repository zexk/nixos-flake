_: {
  flake.nixosModules.lightdm =
    { pkgs, ... }:
    {
      services.xserver.displayManager.lightdm = {
        enable = true;
        extraSeatDefaults = ''
          display-setup-script = ${pkgs.xorg.xrandr}/bin/xrandr --output DisplayPort-0 --primary
        '';
        greeters.gtk = {
          enable = true;
        };
      };
    };
}
