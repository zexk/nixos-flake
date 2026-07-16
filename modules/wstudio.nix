{ inputs, ... }:
{
  flake.homeModules.wstudio = _: {
    imports = [ inputs.wstudio.homeManagerModules.default ];

    programs.wstudio = {
      enable = true;
      settings = {
        gui_font_size = 32;
        gui_theme = "umbra";
      };
    };
  };
}
