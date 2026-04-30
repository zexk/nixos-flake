{ ... }:
{
  flake.homeModules.alacritty = { ... }: {
    programs.alacritty = {
      enable = true;
      settings = {
        font = {
          size = 26;
          normal.family = "IosevkaTermNF";
          bold.family = "IosevkaTermNF";
          italic.family = "IosevkaTermNF";
          bold_italic.family = "IosevkaTermNF";
        };
      };
      theme = "kanagawa_dragon";
    };
  };
}
