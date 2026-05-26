_: {
  flake.homeModules.alacritty =
    { pkgs, ... }:
    {
      fonts.fontconfig = {
        enable = true;
        configFile."50-disable-aa-pixel-font".text = ''
          <?xml version="1.0"?>
          <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
          <fontconfig>
            <match target="font">
              <test name="family" compare="contains">
                <string>PxPlus IBM VGA 8x16</string>
              </test>
              <edit name="antialias" mode="assign">
                <bool>false</bool>
              </edit>
              <edit name="hinting" mode="assign">
                <bool>false</bool>
              </edit>
              <edit name="autohint" mode="assign">
                <bool>false</bool>
              </edit>
              <edit name="hintstyle" mode="assign">
                <const>hintnone</const>
              </edit>
            </match>
          </fontconfig>
        '';
      };

      programs.alacritty = {
        enable = true;
        settings = {
          cursor = {
            style.blinking = "Always";
            unfocused_hollow = true;
          };
          font = {
            builtin_box_drawing = false;
            normal = {
              family = "PxPlus IBM VGA 8x16";
              style = "Regular";
            };
            bold = {
              family = "PxPlus IBM VGA 8x16";
              style = "Regular";
            };
            italic = {
              family = "PxPlus IBM VGA 8x16";
              style = "Regular";
            };
            bold_italic = {
              family = "PxPlus IBM VGA 8x16";
              style = "Regular";
            };
          };
        };
      };
    };
}
