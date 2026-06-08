_: {
  flake.homeModules.pass =
    { pkgs, config, ... }:
    {
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
        };
      };
    };
}
