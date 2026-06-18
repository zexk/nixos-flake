_: {
  flake.homeModules.git = _: {
    programs = {
      git = {
        enable = true;
        signing.format = null;
        settings = {
          user = {
            name = "Bouraoui Ochi";
            email = "bouraouiochi@gmail.com";
          };
          init = {
            defaultBranch = "master";
          };
          push.autoSetupRemote = true;
          pull.rebase = true;
          rebase.autoStash = true;
          merge.conflictstyle = "zdiff3";
          diff.algorithm = "histogram";
        };
      };
      delta = {
        enable = true;
        enableGitIntegration = true;
        options = {
          navigate = true;
          line-numbers = true;
          hyperlinks = true;
        };
      };
      gh = {
        enable = true;
      };
      lazygit = {
        enable = true;
      };
    };
  };
}
