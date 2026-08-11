_: {
  flake.homeModules.fzf = _: {
    programs.fzf = {
      enable = true;
      tmux.enableShellIntegration = true;
      defaultCommand = "fd --type f --hidden --follow --exclude .git";
      defaultOptions = [
        "--height 40%"
        "--border"
      ];
      fileWidget = {
        command = "fd --type f --hidden --follow --exclude .git";
        options = [ "--preview 'bat --color=always --line-range=:200 {}'" ];
      };
      changeDirWidget = {
        command = "fd --type d --hidden --follow --exclude .git";
        options = [ "--preview 'eza --tree --color=always {} | head -80'" ];
      };
      historyWidget.command = "";
    };
  };
}
