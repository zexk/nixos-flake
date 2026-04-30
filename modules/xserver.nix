_:
{
  flake.nixosModules.xserver =
    _:
    {
      services = {
        xserver = {
          enable = true;
          autorun = true;
          xrandrHeads = [
            {
              output = "DP-4";
              primary = true;
              monitorConfig = ''Option "DPMS" "false"'';
            }
            {
              output = "HDMI-0";
              monitorConfig = ''
                Option "DPMS" "false"
                Option "RightOf" "DP-4"
              '';
            }
          ];
        };
      };
    };
}
