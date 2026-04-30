{inputs, ...}:
{
  flake.nixosModules.nh = { config, pkgs, ... }: {
    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "${config.users.users.zexk.home}/repos/nixos-flake";
    };
  };
}
