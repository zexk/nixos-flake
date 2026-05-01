_: {
  flake.nixosModules.steam =
    { pkgs, ... }:
    {
      allowedUnfree = [
        "steam"
        "steam-unwrapped"
      ];

      programs.steam = {
        enable = true;
        protontricks.enable = true;
        package = pkgs.steam.override {
          extraEnv = {
            OBS_VKCAPTURE = true;
          };
        };
        extraPackages = with pkgs; [
          gamescope
          gamemode
        ];
        extraCompatPackages = with pkgs; [ proton-ge-bin ];
        remotePlay.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
      };
    };
}
