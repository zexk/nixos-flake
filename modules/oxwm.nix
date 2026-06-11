{ inputs, ... }:
let
  inherit (inputs.nixpkgs) lib;
  modkey = "Mod4";
  s = inputs.umbra.lib.stripHash;
  p = inputs.umbra.palette;

  # view / move_to / toggleview / toggletag for tags 1-9
  tagBinds = lib.concatLists (
    lib.genList (
      i:
      let
        key = toString (i + 1);
        n = toString i;
      in
      [
        {
          mods = [ modkey ];
          inherit key;
          action = "oxwm.tag.view(${n})";
        }
        {
          mods = [
            modkey
            "Shift"
          ];
          inherit key;
          action = "oxwm.tag.move_to(${n})";
        }
        {
          mods = [
            modkey
            "Control"
          ];
          inherit key;
          action = "oxwm.tag.toggleview(${n})";
        }
        {
          mods = [
            modkey
            "Control"
            "Shift"
          ];
          inherit key;
          action = "oxwm.tag.toggletag(${n})";
        }
      ]
    ) 9
  );
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
      home.file."background-image".source = ../background.png;

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
          };
          gaps = {
            smart = true;
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
            # font = "PxPlus IBM VGA 8x16:style=Regular:pixelsize=8";
            hideVacantTags = true;
            showTitle = true;
            maxTitleLength = 50;
            blocks = [
              {
                kind = "shell";
                format = "{}";
                command = "mpc current --format '%artist% - %title%' 2>/dev/null | cut -c1-50";
                interval = 2;
                color = s p.accents.mauve;
                underline = false;
              }
              {
                kind = "shell";
                format = "vol: {}";
                command = "wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{ if ($3) print $2*100, $3; else print $2*100 }'";
                interval = 2;
                color = s p.accents.magenta;
                underline = false;
              }
              {
                kind = "static";
                text = "│";
                interval = 999999999;
                color = s p.foregrounds.fg3;
                underline = false;
              }
              {
                kind = "ram";
                format = "ram: {used}/{total}GB";
                interval = 5;
                color = s p.accents.iris;
                underline = false;
              }
              {
                kind = "static";
                text = "│";
                interval = 999999999;
                color = s p.foregrounds.fg3;
                underline = false;
              }
              {
                kind = "datetime";
                format = "{}";
                date_format = "%Y/%m/%d %a - %H:%M:%S";
                interval = 1;
                color = s p.foregrounds.fg1;
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
              mods = [
                modkey
                "Shift"
              ];
              key = "s";
              action = ''oxwm.spawn({ "sh", "-c", "maim | xclip -selection clipboard -t image/png" })'';
            }
            {
              mods = [
                modkey
                "Control"
              ];
              key = "s";
              action = ''oxwm.spawn({ "sh", "-c", "mkdir -p ~/pictures/screenshots && maim -s ~/pictures/screenshots/$(date +%Y-%m-%d-%H%M%S).png" })'';
            }
            {
              mods = [
                modkey
                "Control"
                "Shift"
              ];
              key = "s";
              action = ''oxwm.spawn({ "sh", "-c", "mkdir -p ~/pictures/screenshots && maim ~/pictures/screenshots/$(date +%Y-%m-%d-%H%M%S).png" })'';
            }
            # Audio
            {
              mods = [ modkey ];
              key = "Equal";
              action = ''oxwm.spawn({ "sh", "-c", "wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+" })'';
            }
            {
              mods = [ modkey ];
              key = "Minus";
              action = ''oxwm.spawn({ "sh", "-c", "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-" })'';
            }
            {
              mods = [ modkey ];
              key = "m";
              action = ''oxwm.spawn({ "sh", "-c", "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle" })'';
            }
            # Music (mpd)
            {
              mods = [ modkey ];
              key = "backslash";
              action = ''oxwm.spawn({ "sh", "-c", "mpc toggle" })'';
            }
            {
              mods = [ modkey ];
              key = "bracketright";
              action = ''oxwm.spawn({ "sh", "-c", "mpc next" })'';
            }
            {
              mods = [ modkey ];
              key = "bracketleft";
              action = ''oxwm.spawn({ "sh", "-c", "mpc prev" })'';
            }
            # Passwords
            {
              mods = [ modkey ];
              key = "x";
              action = ''oxwm.spawn({ "sh", "-c", "passmenu -l 10" })'';
            }
            # Notifications
            {
              mods = [ modkey ];
              key = "grave";
              action = ''oxwm.spawn({ "sh", "-c", "dunstctl close" })'';
            }
            {
              mods = [
                modkey
                "Shift"
              ];
              key = "grave";
              action = ''oxwm.spawn({ "sh", "-c", "dunstctl history-pop" })'';
            }
            # Screen recording
            {
              mods = [
                modkey
                "Control"
              ];
              key = "r";
              action = ''oxwm.spawn({ "sh", "-c", "clip" })'';
            }
            # Lock screen
            {
              mods = [
                modkey
                "Shift"
              ];
              key = "x";
              action = ''oxwm.spawn({ "sh", "-c", "loginctl lock-session" })'';
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
          ]
          ++ tagBinds;

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
