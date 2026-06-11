_: {
  flake.homeModules.tmux =
    { pkgs, config, ... }:
    {
      xdg.configFile."tms/config.toml".source = (pkgs.formats.toml { }).generate "tms-config" {
        search_dirs = [
          {
            path = "${config.home.homeDirectory}/repos";
            depth = 10;
          }
        ];
      };

      programs.tmux = {
        enable = true;
        shortcut = "s";
        disableConfirmationPrompt = true;
        escapeTime = 0;
        baseIndex = 1;
        keyMode = "vi";
        plugins = with pkgs.tmuxPlugins; [
          fuzzback
          yank
          {
            plugin = resurrect;
            extraConfig = "set -g @resurrect-strategy-nvim 'session'";
          }
          {
            plugin = continuum;
            extraConfig = ''
              set -g @continuum-restore 'on'
              set -g @continuum-save-interval '60'
            '';
          }
        ];
        extraConfig = ''
          bind-key -r f run-shell "tmux neww tms"
          bind-key -r j run-shell "tms switch"
        '';
      };
    };
}
