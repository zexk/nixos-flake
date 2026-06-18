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
