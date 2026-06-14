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

        # notify when a foreground command takes longer than 30s
        initExtra = ''
          __cmd_timer_arm=1
          trap '[ -n "$__cmd_timer_arm" ] && { __cmd_start=$EPOCHSECONDS; __cmd_line=$BASH_COMMAND; unset __cmd_timer_arm; }' DEBUG

          __cmd_notify() {
            local status=$?
            if [ -n "$__cmd_start" ]; then
              local dur=$((EPOCHSECONDS - __cmd_start))
              case "''${__cmd_line%% *}" in
                nvim|vim|v|less|man|ssh|tmux|lazygit|lg|btop|fzf|mpv|watch|calcurse|claude) ;;
                *)
                  if [ "$dur" -ge 30 ]; then
                    notify-send -a terminal "done in ''${dur}s (exit $status)" "$__cmd_line"
                  fi
                  ;;
              esac
              unset __cmd_start __cmd_line
            fi
            __cmd_timer_arm=1
          }
          PROMPT_COMMAND="''${PROMPT_COMMAND:+$PROMPT_COMMAND;}__cmd_notify"
        '';
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
