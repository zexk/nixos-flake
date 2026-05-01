_: {
  flake.homeModules.zed = _: {
    programs.zed-editor = {
      enable = true;
      enableMcpIntegration = true;
      extensions = [
        "nix"
        "toml"
        "kanagawa-themes"
      ];
      userSettings = {
        vim_mode = true;
        theme = {
          mode = "dark";
          dark = "Kanagawa Dragon - No Italics";
        };
        ui_font_size = 16;
        buffer_font_size = 24;
        load_direnv = "shell_hook";
      };
    };
  };
}
