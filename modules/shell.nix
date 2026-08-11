_: {
  flake.homeModules.shell = _: {
    home = {
      shellAliases = {
        v = "nvim";
        g = "git";
        lg = "lazygit";
        cp = "cp -iv";
        mv = "mv -iv";
        rm = "rm -iv";
        mkdir = "mkdir -pv";
      };

      sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };
    };

    programs = {
      fish.enable = true;

      nix-your-shell = {
        enable = true;
        enableFishIntegration = true;

        nix-output-monitor.enable = true;
      };
    };
  };
}
