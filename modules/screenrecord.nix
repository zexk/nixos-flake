_: {
  flake.homeModules.screenrecord =
    { pkgs, ... }:
    let
      # default ffmpeg lacks x11grab; enable just the xcb bits instead of
      # pulling in ffmpeg-full (shm = fast capture, xfixes = cursor)
      ffmpeg = pkgs.ffmpeg.override {
        withXcbShm = true;
        withXcbxfixes = true;
        withXcbShape = true;
      };
    in
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
            # slop prints no trailing newline, which makes read report failure
            geom=$(${pkgs.slop}/bin/slop -f '%x %y %w %h') || exit 1
            read -r x y w h <<< "$geom"
            # libx264 needs even dimensions
            w=$((w / 2 * 2)) h=$((h / 2 * 2))
            ${ffmpeg}/bin/ffmpeg -y -f x11grab -framerate 60 -video_size "''${w}x''${h}" \
              -i "$DISPLAY+$x,$y" "$dir/$(date +%Y-%m-%d-%H%M%S).mp4" &
            echo $! > "$pidfile"
            ${pkgs.libnotify}/bin/notify-send -a clip "recording started"
          fi
        '')
      ];
    };
}
