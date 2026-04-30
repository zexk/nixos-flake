_:
{
  flake.nixosModules.networkmanager =
    _:
    {
      networking.networkmanager = {
        enable = true;
        wifi.powersave = false;
      };
    };
}
