_: {
  flake.homeModules.zsh =
    { config, ... }:
    {
      programs.bash = {
        enable = true;
        enableCompletion = true;
        historyControl = [
          "ignoredups"
          "ignorespace"
        ];
        historySize = 100000;
        historyFile = "${config.xdg.stateHome}/bash/history";
        shellAliases = {
          v = "nvim";
          g = "git";
          lg = "lazygit";
          cp = "cp -iv";
          mv = "mv -iv";
          rm = "rm -iv";
          mkdir = "mkdir -pv";
        };
      };

      home = {
        shell.enableBashIntegration = true;
        sessionVariables = {
          EDITOR = "nvim";
          VISUAL = "nvim";
        };
      };
    };
}
