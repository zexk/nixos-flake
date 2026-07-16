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
            # notify when a foreground command takes longer than 30s
            initExtra = ''
              __cmd_last_hist=0
              __cmd_start=$EPOCHSECONDS

              __cmd_notify() {
                local status=$_ps1_exit
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
              }

              __ps1() {
                local last=$_ps1_exit
                local dur=$(( EPOCHSECONDS - __cmd_start ))
                local dur_str=
                if (( dur >= 1 )); then
                  if (( dur >= 60 )); then
                    printf -v dur_str "[%dm %ds]" $((dur/60)) $((dur%60))
                  else
                    printf -v dur_str "[%ds]" $dur
                  fi
                fi
                if (( EUID == 0 )); then
                  PS1='\[\e[31m\](>_<)\[\e[0m\]'
                else
                  PS1='\[\e[90m\](._.)\[\e[0m\]'
                fi
                PS1+='@\[\e[32m\]\h\[\e[0m\] \[\e[36m\]\w\[\e[0m\]'
                PS1+='\[\e[35m\]$(__git_ps1 " %s" 2>/dev/null)\[\e[0m\]'
                if [[ -n $dur_str ]]; then
                  PS1+='\[\e[90m\]'"$dur_str"'\[\e[0m\]'
                fi
                PS1+='\n'
                if (( last == 0 )); then
                  PS1+='\[\e[32m\]\$\[\e[0m\] '
                else
                  PS1+='\[\e[31m\]\$\[\e[0m\] '
                fi
                __cmd_start=$EPOCHSECONDS
              }

              PROMPT_COMMAND='_ps1_exit=$?; __cmd_notify; __ps1'
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

      home.shell.enableBashIntegration = lib.mkIf config.programs.bash.enable true;
    };
}
