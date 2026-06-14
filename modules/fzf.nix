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
      fileWidgetCommand = "fd --type f --hidden --follow --exclude .git";
      fileWidgetOptions = [ "--preview 'bat --color=always --line-range=:200 {}'" ];
      changeDirWidgetCommand = "fd --type d --hidden --follow --exclude .git";
      changeDirWidgetOptions = [ "--preview 'eza --tree --color=always {} | head -80'" ];
    };
  };
}
