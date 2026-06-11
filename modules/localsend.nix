_: {
  flake.nixosModules.localsend = _: {
    programs.localsend = {
      enable = true;
      openFirewall = true;
    };
  };
}
