_: {
  flake.nixosModules.xserver = _: {
    services = {
      xserver = {
        enable = true;
        autorun = true;
        xrandrHeads = [
          {
            output = "DisplayPort-0";
            primary = true;
            monitorConfig = ''Option "DPMS" "false"'';
          }
          {
            output = "HDMI-A-0";
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
