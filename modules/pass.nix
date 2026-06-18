_: {
  flake.homeModules.pass =
    { pkgs, config, ... }:
    {
      home.packages = [
        (pkgs.writeShellScriptBin "pass-fix" ''
          set -euo pipefail
          PATH="${pkgs.gnugrep}/bin:${pkgs.coreutils}/bin:${pkgs.findutils}/bin:${pkgs.pass}/bin:$PATH"
          paths=$(${pkgs.pass}/bin/pass audit 2>&1 | ${pkgs.gnugrep}/bin/grep -oP 'from \K\S+(?= has been breached| might be weak)' | ${pkgs.coreutils}/bin/sort -u || true)
          if [ -z "$paths" ]; then
            echo "No breached or weak passwords found."
            exit 0
          fi
          count=$(echo "$paths" | ${pkgs.coreutils}/bin/wc -l)
          echo "Found $count breached/weak passwords:"
          echo "$paths"
          echo ""
          echo "Updating all of them..."
          echo "$paths" | ${pkgs.coreutils}/bin/tr '\n' ' ' | ${pkgs.findutils}/bin/xargs -r ${pkgs.pass}/bin/pass update -f -n -a
          echo ""
          echo "Done. Run 'pass audit' to verify."
        '')
      ];
      programs.password-store = {
        enable = true;
        package = pkgs.pass.withExtensions (
          exts: with exts; [
            pass-otp
            pass-audit
            pass-update
            pass-import
          ]
        );
        settings = {
          PASSWORD_STORE_DIR = "${config.xdg.dataHome}/password-store";
          PASSWORD_STORE_GENERATED_LENGTH = "32";
          PASSWORD_STORE_GPG_OPTS = "--no-symkey-cache";
          PASSWORD_STORE_CLIP_TIME = "15";
          PASSWORD_STORE_KEY = "9FBA8D56C72EB135";
        };
      };
    };
}
