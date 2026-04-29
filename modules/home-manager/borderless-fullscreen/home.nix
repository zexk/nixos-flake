{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "borderless-fullscreen";
      text = builtins.readFile ./borderless-fullscreen;
      runtimeInputs = with pkgs; [
        xdotool
        zenity
      ];
    })
  ];
}
