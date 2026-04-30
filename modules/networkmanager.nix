{ ... }:
{
  flake.nixosModules.networkmanager = { ... }: {
    networking.networkmanager = {
      enable = true;
      wifi.powersave = false;
    };
  };
}
