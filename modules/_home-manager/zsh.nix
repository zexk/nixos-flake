{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    historyControl = [ "ignoredups" ];
  };

  home = {
    shell.enableBashIntegration = true;
  };
}
