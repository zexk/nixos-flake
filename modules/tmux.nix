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
          {
            plugin = ukiyo;
            extraConfig = ''
              set -g @ukiyo-theme "kanagawa/dragon"
              set -g @ukiyo-ignore-window-colors true
              set -g @ukiyo-plugins "cpu-usage ram-usage"
              set -g @ukiyo-cpu-usage-label ""
              set -g @ukiyo-ram-usage-label ""
            '';
          }
        ];
      };
    };
}
