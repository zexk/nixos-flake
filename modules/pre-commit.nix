_: {
  perSystem =
    { pkgs, ... }:
    {
      pre-commit.settings = {
        src = ../.;
        hooks = {
          nixfmt.enable = true;
          flake-lock-commit = {
            enable = true;
            name = "flake-lock-commit";
            entry = "${pkgs.writeShellScript "flake-lock-commit" ''
              if ! git diff --name-only HEAD -- flake.lock | grep -q .; then
                exit 0
              fi
              other_staged=$(git diff --cached --name-only --diff-filter=ACM | grep -v '^flake.lock$' || true)
              if [ -n "$other_staged" ]; then
                git restore --staged $other_staged
                git add flake.lock
                git commit -m "chore: update flake.lock" --no-verify
                git add $other_staged
              fi
            ''}";
            language = "system";
            pass_filenames = false;
          };
        };
      };
    };
}
