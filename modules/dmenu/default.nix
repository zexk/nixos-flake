{ inputs, ... }:
let
  p = inputs.umbra.palette;
in
{
  flake.homeModules.dmenu =
    { pkgs, ... }:
    let
      dmenu = pkgs.symlinkJoin {
        name = "dmenu";
        paths = [ (pkgs.callPackage ../../pkgs/dmenu { }) ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        # call-site flags are parsed after these, so they still override
        postBuild = ''
          wrapProgram $out/bin/dmenu \
            --add-flags "-fn 'Tessera Mono:style=Regular:pixelsize=16'" \
            --add-flags "-nb '${p.backgrounds.bg1}' -nf '${p.foregrounds.fg1}'" \
            --add-flags "-sb '${p.accents.iris}' -sf '${p.backgrounds.bg0}'"
        '';
      };
    in
    {
      home.packages = [
        dmenu

        (pkgs.writeShellApplication {
          name = "dmenu-power";
          runtimeInputs = [
            dmenu
            pkgs.systemd
          ];
          text = ''
            choice=$(printf 'lock\nsuspend\nreboot\npoweroff\n' | dmenu -p power) || exit 0
            case "$choice" in
              lock) loginctl lock-session ;;
              suspend) systemctl suspend ;;
              reboot) systemctl reboot ;;
              poweroff) systemctl poweroff ;;
            esac
          '';
        })

        (pkgs.writeShellApplication {
          name = "dmenu-mpd";
          runtimeInputs = [
            dmenu
            pkgs.mpc
          ];
          # both listall calls return database order, so the picked line
          # number maps back to the file path
          text = ''
            list=$(mpc listall -f '[[%artist% - ]%title%]|%file%')
            [ -n "$list" ] || exit 0
            choice=$(printf '%s\n' "$list" | dmenu -i -l 20 -p mpd) || exit 0
            idx=$(printf '%s\n' "$list" | grep -nxF -- "$choice" | head -1 | cut -d: -f1)
            mpc add "$(mpc listall -f '%file%' | sed -n "''${idx}p")"
            mpc play "$(mpc playlist | wc -l)"
          '';
        })

        (pkgs.writeShellApplication {
          name = "dmenu-emoji";
          runtimeInputs = [
            dmenu
            pkgs.xclip
            pkgs.libnotify
          ];
          text = ''
            choice=$(sed -n 's/^[^#]*; fully-qualified[[:space:]]*# \([^ ]*\) E[0-9.]* \(.*\)$/\1 \2/p' \
              ${pkgs.unicode-emoji}/share/unicode/emoji/emoji-test.txt \
              | dmenu -i -l 20 -p emoji) || exit 0
            emoji=''${choice%% *}
            printf '%s' "$emoji" | xclip -selection clipboard
            notify-send -a emoji "copied $emoji"
          '';
        })

        (pkgs.writeShellApplication {
          name = "dmenu-kill";
          runtimeInputs = [
            dmenu
            pkgs.procps
          ];
          text = ''
            choice=$(ps --user "$USER" -o pid=,pcpu=,pmem=,comm= --sort=-pcpu \
              | dmenu -i -l 20 -p kill) || exit 0
            kill "$(printf '%s\n' "$choice" | awk '{print $1}')"
          '';
        })
      ];
    };
}
