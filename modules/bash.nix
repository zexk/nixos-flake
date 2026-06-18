_: {
  flake.homeModules.bash =
    { config, lib, ... }:
    {
      programs = lib.mkMerge [
        {
          bash = {
            enable = true;
            enableCompletion = true;
            enableVteIntegration = true;
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
              __cmd_last_hist=0
              __cmd_start=$EPOCHSECONDS

              __cmd_notify() {
                local status=$?
                local now=$EPOCHSECONDS n cmd
                read -r n cmd <<< "$(HISTTIMEFORMAT= history 1)"
                if [[ $n =~ ^[0-9]+$ ]] && (( n != __cmd_last_hist )); then
                  local dur=$(( now - __cmd_start ))
                  case "''${cmd%% *}" in
                    nvim|vim|v|less|man|ssh|tmux|lazygit|lg|btop|fzf|mpv|watch|calcurse|claude) ;;
                    *)
                      if (( dur >= 30 )); then
                        local fmt
                        if (( dur >= 3600 )); then
                          fmt="$((dur/3600))h $((dur%3600/60))m"
                        elif (( dur >= 60 )); then
                          fmt="$((dur/60))m $((dur%60))s"
                        else
                          fmt="''${dur}s"
                        fi
                        notify-send -a terminal "done in $fmt (exit $status)" "$cmd"
                      fi
                      ;;
                  esac
                fi
                __cmd_last_hist=''${n:-0}
                __cmd_start=$now
              }
              PROMPT_COMMAND="''${PROMPT_COMMAND:+$PROMPT_COMMAND;}__cmd_notify"
            '';
          };
        }
        (lib.mkIf config.programs.bash.enable {
          zoxide.enableBashIntegration = true;
          fzf.enableBashIntegration = true;
          atuin.enableBashIntegration = true;
          direnv.enableBashIntegration = true;
          eza.enableBashIntegration = true;
          nix-index.enableBashIntegration = true;
        })
      ];

      home = lib.mkIf config.programs.bash.enable {
        shell.enableBashIntegration = true;
        sessionVariables = {
          EDITOR = "nvim";
          VISUAL = "nvim";
        };
      };
    };
}
