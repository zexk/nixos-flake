_: {
  flake.homeModules.ludusavi =
    { pkgs, config, ... }:
    {
      home.packages = [ pkgs.ludusavi ];

      xdg.configFile."ludusavi/config.yaml".source = (pkgs.formats.yaml { }).generate "ludusavi-config" {
        manifest.url = "https://raw.githubusercontent.com/mtkennerly/ludusavi-manifest/master/data/manifest.yaml";
        backup = {
          path = "${config.home.homeDirectory}/backups/saves";
          format.chosen = "zip";
        };
      };

      systemd.user.services.ludusavi-backup = {
        Unit.Description = "back up game saves";
        Service = {
          Type = "oneshot";
          ExecStart = "${pkgs.ludusavi}/bin/ludusavi backup --force";
        };
      };

      systemd.user.timers.ludusavi-backup = {
        Unit.Description = "daily game save backup";
        Timer = {
          OnCalendar = "daily";
          Persistent = true;
        };
        Install.WantedBy = [ "timers.target" ];
      };
    };
}
