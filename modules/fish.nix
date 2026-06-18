_: {
  flake.homeModules.fish =
    { config, lib, ... }:
    {
      programs = lib.mkMerge [
        {
          fish = {
            enable = true;
            generateCompletions = true;
            preferAbbrs = true;
            shellAbbrs = {
              v = "nvim";
              g = "git";
              lg = "lazygit";
              cp = "cp -iv";
              mv = "mv -iv";
              rm = "rm -iv";
              mkdir = "mkdir -pv";
            };
            interactiveShellInit = ''
              set -g fish_autosuggestion_enabled 0
              set -g fish_greeting ""
            '';
            functions = {
              fish_prompt = {
                body = ''
                  if test (id -u) -eq 0
                    echo -n (set_color red)'(>_<)'
                  else
                    echo -n (set_color brblack)'(._.)'
                  end
                  echo -n (set_color normal)@(set_color green)(hostname -s)
                  echo -n (set_color normal)' '(set_color cyan)(prompt_pwd)
                  set -l git_info (fish_git_prompt 2>/dev/null)
                  if test -n "$git_info"
                    echo -n (set_color normal)' '(set_color magenta)$git_info
                  end
                  echo
                  if test $pipestatus[1] -eq 0
                    set_color green
                  else
                    set_color red
                  end
                  echo -n '❯ '
                  set_color normal
                '';
              };
              fish_right_prompt = {
                body = ''
                  if test $CMD_DURATION -ge 1000
                    set -l secs (math "$CMD_DURATION / 1000" 2>/dev/null)
                    if test $secs -ge 60
                      set_color brblack
                      printf '%dm %ds' (math "$secs / 60") (math "$secs % 60")
                    else
                      set_color brblack
                      printf '%ds' $secs
                    end
                    set_color normal
                  end
                '';
              };
            };
          };
        }
        (lib.mkIf config.programs.fish.enable {
          zoxide.enableFishIntegration = true;
          fzf.enableFishIntegration = true;
          atuin.enableFishIntegration = true;
          direnv.enableFishIntegration = true;
          eza.enableFishIntegration = true;
          nix-index.enableFishIntegration = true;
        })
      ];

      home = lib.mkIf config.programs.fish.enable {
        shell.enableFishIntegration = true;
        sessionVariables = {
          EDITOR = "nvim";
          VISUAL = "nvim";
        };
      };
    };
}
