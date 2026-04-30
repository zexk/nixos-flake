_:
{
  flake.homeModules.mpd =
    { config, ... }:
    {
      services.mpd = {
        enable = true;
        extraConfig = ''
          follow_outside_symlinks "yes"
          follow_inside_symlinks "yes"
        '';
        musicDirectory = "${config.home.homeDirectory}/music";
        network.listenAddress = "any";
        network.startWhenNeeded = true;
      };
    };
}
