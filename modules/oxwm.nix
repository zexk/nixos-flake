_:
let
  modkey = "Mod4";

  # Kanagawa Dragon palette (ARGB 8-digit — strip leading # when passed to the module)
  c = {
    bg = "ff181616";
    fg = "ffc5c9c5";
    black = "ff0d0c0c";
    blue = "ff8ba4b0";
    cyan = "ff8ea4a2";
    green = "ff8a9a7b";
    magenta = "ffa292a3";
    red = "ffc4746e";
    white = "ffc8c093";
    yellow = "ffc4b28a";
  };
in
{
  flake.nixosModules.oxwm =
    { inputs, pkgs, ... }:
    {
      services.xserver.windowManager.oxwm = {
        enable = true;
        package = inputs.oxwm.packages.${pkgs.stdenv.hostPlatform.system}.default;
      };
    };

  flake.homeModules.oxwm =
    { config, ... }:
    {
      programs.oxwm = {
        enable = true;
        settings = {
          terminal = "alacritty";
          inherit modkey;
          tags = [
            "1"
            "2"
            "3"
            "4"
            "5"
            "6"
            "7"
            "8"
            "9"
          ];
          layoutSymbol = {
            tiling = "[t]";
            normie = "[f]";
            tabbed = "[=]";
          };
          border = {
            width = 3;
            focusedColor = c.magenta;
            unfocusedColor = c.bg;
          };
          gaps = {
            smart = "true";
            inner = [
              12
              12
            ];
            outer = [
              12
              12
            ];
          };
          bar = {
            font = "IosevkaTerm Nerd Font:style=Regular:size=14";
            hideVacantTags = true;

            unoccupiedScheme = [
              c.fg
              c.bg
              "444444"
            ];
            occupiedScheme = [
              c.fg
              c.magenta
              c.cyan
            ];
            selectedScheme = [
              c.fg
              c.green
              c.magenta
            ];
            urgentScheme = [
              c.fg
              c.red
              c.red
            ];

            blocks = [
              {
                kind = "ram";
                format = "ram: {used}/{total}GB";
                interval = 5;
                color = c.cyan;
                underline = true;
              }
              {
                kind = "static";
                text = "│";
                interval = 999999999;
                color = c.fg;
                underline = false;
              }
              {
                kind = "datetime";
                format = "{}";
                date_format = "%Y/%m/%d %a - %H:%M:%S";
                interval = 1;
                color = c.fg;
                underline = false;
              }
            ];
          };

          rules = [
            {
              match.instance = "drawy";
              tag = 6;
              fullscreen = true;
            }
          ];

          autostart = [
            "feh --bg-scale ${config.home.homeDirectory}/background-image"
          ];

          # ── Keybinds ─────────────────────────────────────────────────────────
          binds = [
            {
              mods = [ modkey ];
              key = "p";
              action = ''oxwm.spawn({ "sh", "-c", "dmenu_run -l 10" })'';
            }
            {
              mods = [ modkey ];
              key = "s";
              action = ''oxwm.spawn({ "sh", "-c", "maim -s | xclip -selection clipboard -t image/png" })'';
            }
            {
              mods = [ modkey ];
              key = "q";
              action = "oxwm.client.kill()";
            }
            {
              mods = [
                modkey
                "Shift"
              ];
              key = "Slash";
              action = "oxwm.show_keybinds()";
            }
            # Window state
            {
              mods = [ modkey ];
              key = "f";
              action = "oxwm.client.toggle_fullscreen()";
            }
            {
              mods = [
                modkey
                "Shift"
              ];
              key = "Space";
              action = "oxwm.client.toggle_floating()";
            }
            # Layouts
            {
              mods = [ modkey ];
              key = "n";
              action = "oxwm.layout.cycle()";
            }
            {
              mods = [ modkey ];
              key = "h";
              action = "oxwm.set_master_factor(-20)";
            }
            {
              mods = [ modkey ];
              key = "l";
              action = "oxwm.set_master_factor(20)";
            }
            # Session
            {
              mods = [
                modkey
                "Shift"
              ];
              key = "q";
              action = "oxwm.quit()";
            }
            {
              mods = [
                modkey
                "Shift"
              ];
              key = "r";
              action = "oxwm.restart()";
            }
            # Focus / move in stack
            {
              mods = [ modkey ];
              key = "j";
              action = "oxwm.client.focus_stack(1)";
            }
            {
              mods = [ modkey ];
              key = "k";
              action = "oxwm.client.focus_stack(-1)";
            }
            {
              mods = [
                modkey
                "Shift"
              ];
              key = "j";
              action = "oxwm.client.move_stack(1)";
            }
            {
              mods = [
                modkey
                "Shift"
              ];
              key = "k";
              action = "oxwm.client.move_stack(-1)";
            }
            # Monitors
            {
              mods = [ modkey ];
              key = "Comma";
              action = "oxwm.monitor.focus(-1)";
            }
            {
              mods = [ modkey ];
              key = "Period";
              action = "oxwm.monitor.focus(1)";
            }
            {
              mods = [
                modkey
                "Shift"
              ];
              key = "Comma";
              action = "oxwm.monitor.tag(-1)";
            }
            {
              mods = [
                modkey
                "Shift"
              ];
              key = "Period";
              action = "oxwm.monitor.tag(1)";
            }
            # Tag view
            {
              mods = [ modkey ];
              key = "1";
              action = "oxwm.tag.view(0)";
            }
            {
              mods = [ modkey ];
              key = "2";
              action = "oxwm.tag.view(1)";
            }
            {
              mods = [ modkey ];
              key = "3";
              action = "oxwm.tag.view(2)";
            }
            {
              mods = [ modkey ];
              key = "4";
              action = "oxwm.tag.view(3)";
            }
            {
              mods = [ modkey ];
              key = "5";
              action = "oxwm.tag.view(4)";
            }
            {
              mods = [ modkey ];
              key = "6";
              action = "oxwm.tag.view(5)";
            }
            {
              mods = [ modkey ];
              key = "7";
              action = "oxwm.tag.view(6)";
            }
            {
              mods = [ modkey ];
              key = "8";
              action = "oxwm.tag.view(7)";
            }
            {
              mods = [ modkey ];
              key = "9";
              action = "oxwm.tag.view(8)";
            }
            # Move window to tag
            {
              mods = [
                modkey
                "Shift"
              ];
              key = "1";
              action = "oxwm.tag.move_to(0)";
            }
            {
              mods = [
                modkey
                "Shift"
              ];
              key = "2";
              action = "oxwm.tag.move_to(1)";
            }
            {
              mods = [
                modkey
                "Shift"
              ];
              key = "3";
              action = "oxwm.tag.move_to(2)";
            }
            {
              mods = [
                modkey
                "Shift"
              ];
              key = "4";
              action = "oxwm.tag.move_to(3)";
            }
            {
              mods = [
                modkey
                "Shift"
              ];
              key = "5";
              action = "oxwm.tag.move_to(4)";
            }
            {
              mods = [
                modkey
                "Shift"
              ];
              key = "6";
              action = "oxwm.tag.move_to(5)";
            }
            {
              mods = [
                modkey
                "Shift"
              ];
              key = "7";
              action = "oxwm.tag.move_to(6)";
            }
            {
              mods = [
                modkey
                "Shift"
              ];
              key = "8";
              action = "oxwm.tag.move_to(7)";
            }
            {
              mods = [
                modkey
                "Shift"
              ];
              key = "9";
              action = "oxwm.tag.move_to(8)";
            }
            # Toggle-view (show tag alongside current)
            {
              mods = [
                modkey
                "Control"
              ];
              key = "1";
              action = "oxwm.tag.toggleview(0)";
            }
            {
              mods = [
                modkey
                "Control"
              ];
              key = "2";
              action = "oxwm.tag.toggleview(1)";
            }
            {
              mods = [
                modkey
                "Control"
              ];
              key = "3";
              action = "oxwm.tag.toggleview(2)";
            }
            {
              mods = [
                modkey
                "Control"
              ];
              key = "4";
              action = "oxwm.tag.toggleview(3)";
            }
            {
              mods = [
                modkey
                "Control"
              ];
              key = "5";
              action = "oxwm.tag.toggleview(4)";
            }
            {
              mods = [
                modkey
                "Control"
              ];
              key = "6";
              action = "oxwm.tag.toggleview(5)";
            }
            {
              mods = [
                modkey
                "Control"
              ];
              key = "7";
              action = "oxwm.tag.toggleview(6)";
            }
            {
              mods = [
                modkey
                "Control"
              ];
              key = "8";
              action = "oxwm.tag.toggleview(7)";
            }
            {
              mods = [
                modkey
                "Control"
              ];
              key = "9";
              action = "oxwm.tag.toggleview(8)";
            }
            # Assign window to multiple tags
            {
              mods = [
                modkey
                "Control"
                "Shift"
              ];
              key = "1";
              action = "oxwm.tag.toggletag(0)";
            }
            {
              mods = [
                modkey
                "Control"
                "Shift"
              ];
              key = "2";
              action = "oxwm.tag.toggletag(1)";
            }
            {
              mods = [
                modkey
                "Control"
                "Shift"
              ];
              key = "3";
              action = "oxwm.tag.toggletag(2)";
            }
            {
              mods = [
                modkey
                "Control"
                "Shift"
              ];
              key = "4";
              action = "oxwm.tag.toggletag(3)";
            }
            {
              mods = [
                modkey
                "Control"
                "Shift"
              ];
              key = "5";
              action = "oxwm.tag.toggletag(4)";
            }
            {
              mods = [
                modkey
                "Control"
                "Shift"
              ];
              key = "6";
              action = "oxwm.tag.toggletag(5)";
            }
            {
              mods = [
                modkey
                "Control"
                "Shift"
              ];
              key = "7";
              action = "oxwm.tag.toggletag(6)";
            }
            {
              mods = [
                modkey
                "Control"
                "Shift"
              ];
              key = "8";
              action = "oxwm.tag.toggletag(7)";
            }
            {
              mods = [
                modkey
                "Control"
                "Shift"
              ];
              key = "9";
              action = "oxwm.tag.toggletag(8)";
            }
          ];

          # ── Key chords ───────────────────────────────────────────────────────
          chords = [
            {
              notes = [
                {
                  mods = [ modkey ];
                  key = "Space";
                }
                {
                  mods = [ ];
                  key = "t";
                }
              ];
              action = "oxwm.spawn_terminal()";
            }
          ];

          # ── Anything without a typed option ──────────────────────────────────
          extraConfig = ''
            oxwm.set_floating_position("center")
          '';
        };
      };
    };
}
