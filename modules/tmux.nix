_: {
  flake.homeModules.tmux =
    { pkgs, ... }:
    {
      programs.tmux = {
        enable = true;
        shortcut = "s";
        disableConfirmationPrompt = true;
        escapeTime = 0;
        baseIndex = 1;
        keyMode = "vi";
        plugins = with pkgs.tmuxPlugins; [
          fuzzback
          {
            plugin = resurrect;
            extraConfig = "set -g @resurrect-strategy-nvim 'session'";
          }
          {
            plugin = continuum;
            extraConfig = ''
              set -g @continuum-restore 'on'
              set -g @continuum-save-interval '60' # minutes
            '';
          }
        ];
      };
    };
}
