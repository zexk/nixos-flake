_:
{
  flake.homeModules.fzf =
    _:
    {
      programs.fzf = {
        enable = true;
        enableBashIntegration = true;
        tmux.enableShellIntegration = true;
      };
    };
}
