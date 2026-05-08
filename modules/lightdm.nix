_: {
  flake.nixosModules.lightdm =
    { pkgs, ... }:
    let
      kanagawa-dragon = import ./_kanagawa-theme.nix { inherit pkgs; };
    in
    {
      services.xserver.displayManager.lightdm = {
        enable = true;
        greeters.gtk = {
          enable = true;
          theme.name = "Kanagawa-Dark-Dragon";
        };
      };

      environment.systemPackages = [ kanagawa-dragon ];
    };
}
