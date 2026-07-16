_: {
  flake.homeModules.alacritty =
    { ... }:
    {
      fonts.fontconfig = {
        enable = true;
        configFile."50-disable-aa-pixel-font".text = ''
          <?xml version="1.0"?>
          <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
          <fontconfig>
            <match target="font">
              <test name="family" compare="contains">
                <string>Tessera Mono</string>
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
          window = {
            dynamic_padding = false;
            padding = {
              x = 8;
              y = 4;
            };
          };
          cursor = {
            style.blinking = "Always";
            unfocused_hollow = true;
          };
          font = {
            builtin_box_drawing = false;
            # Two strikes are installed (16px + 32px). Pin the terminal to the
            # 32px strike; freetype snaps a bitmap face to the nearest fixed
            # size and renders it natively (no scaling).
            size = 32;
            normal = {
              family = "Tessera Mono";
              style = "Regular";
            };
            bold = {
              family = "Tessera Mono";
              style = "Regular";
            };
            italic = {
              family = "Tessera Mono";
              style = "Regular";
            };
            bold_italic = {
              family = "Tessera Mono";
              style = "Regular";
            };
          };
        };
      };
    };
}
