_: {
  flake.nixosModules.slock = _: {
    programs.slock.enable = true;

    # makes `loginctl lock-session` and pre-suspend locking work
    programs.xss-lock = {
      enable = true;
      lockerCommand = "/run/wrappers/bin/slock";
    };
  };
}
