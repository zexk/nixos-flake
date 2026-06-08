_: {
  flake.nixosModules.komga =
    { ... }:
    {
      services.komga = {
        enable = true;
        openFirewall = true;
      };
    };
}
