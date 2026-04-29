{
  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    colors = "always";
    git = true;
    extraOptions = [
      "--group-directories-first"
      "--header"
    ];
  };
}
