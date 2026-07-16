_: {
  flake.homeModules.fastfetch = _: {
    programs.fastfetch = {
      enable = true;
      settings = {
        logo = {
          type = "none";
        };
        display = {
          separator = ": ";
          key = {
            width = 12;
          };
        };
        modules = [
          {
            type = "os";
            format = "{name}";
          }
          {
            type = "kernel";
            format = "{release}";
          }
          "uptime"
          {
            type = "packages";
            combined = true;
          }
          "shell"
          "wm"
          "theme"
          "terminal"
          {
            type = "cpu";
            format = "{name}";
          }
          "gpu"
          {
            type = "memory";
            format = "{used} / {total}";
          }
          "break"
          "colors"
        ];
      };
    };
  };
}
