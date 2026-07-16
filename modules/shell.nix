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
  };
}
