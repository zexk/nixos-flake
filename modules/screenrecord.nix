_: {
  flake.homeModules.screenrecord =
    { pkgs, ... }:
    {
      home.packages = [
        (pkgs.writeShellScriptBin "clip" ''
          pidfile=''${XDG_RUNTIME_DIR:-/tmp}/clip-record.pid

          if [ -f "$pidfile" ] && kill -0 "$(cat "$pidfile")" 2>/dev/null; then
            kill -INT "$(cat "$pidfile")"
            rm -f "$pidfile"
            ${pkgs.libnotify}/bin/notify-send -a clip "recording stopped" "saved to ~/videos/clips"
          else
            dir=$HOME/videos/clips
            mkdir -p "$dir"
            read -r x y w h < <(${pkgs.slop}/bin/slop -f '%x %y %w %h') || exit 1
            # libx264 needs even dimensions
            w=$((w / 2 * 2)) h=$((h / 2 * 2))
            ${pkgs.ffmpeg}/bin/ffmpeg -y -f x11grab -framerate 60 -video_size "''${w}x''${h}" \
              -i "$DISPLAY+$x,$y" "$dir/$(date +%Y-%m-%d-%H%M%S).mp4" &
            echo $! > "$pidfile"
            ${pkgs.libnotify}/bin/notify-send -a clip "recording started"
          fi
        '')
      ];
    };
}
