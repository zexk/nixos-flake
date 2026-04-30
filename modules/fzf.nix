{ ... }:
{
  flake.homeModules.fzf = { ... }: {
    programs.fzf = {
      enable = true;
      enableBashIntegration = true;
      tmux.enableShellIntegration = true;
    };
  };
}
