_: {
  flake.homeModules.gtk =
    { pkgs, ... }:
    {
      gtk = {
        enable = true;
        theme = {
          name = "Kanagawa-BL-LB";
          package = pkgs.kanagawa-gtk-theme;
        };
        gtk4.theme = null;
      };
    };
}
