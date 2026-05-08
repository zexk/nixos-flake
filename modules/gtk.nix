_: {
  flake.homeModules.gtk =
    { pkgs, ... }:
    let
      kanagawa-dragon = import ./_kanagawa-theme.nix { inherit pkgs; };
    in
    {
      gtk = {
        enable = true;
        theme = {
          name = "Kanagawa-Dark-Dragon";
          package = kanagawa-dragon;
        };
        gtk4.theme = null;
      };
    };
}
