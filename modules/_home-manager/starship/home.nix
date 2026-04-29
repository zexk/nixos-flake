{ lib, ... }:
{
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      add_newline = false;
      format = lib.concatStrings [
        "$directory"
        "$git_status"
        "$git_branch"
        "$direnv"
        "$line_break"
        "$character"
      ];
      scan_timeout = 10;
      character = {
      };
    };
  };
}
