_: {
  flake.nixosModules.openssh = _: {
    services.openssh = {
      enable = true;
      ports = [ 22 ];
      settings = {
        PasswordAuthentication = false;
        AllowUsers = null;
        UseDns = false;
        X11Forwarding = false;
        PermitRootLogin = "prohibit-password";
      };
    };
  };
}
