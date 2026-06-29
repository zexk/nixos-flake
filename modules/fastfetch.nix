_: {
  flake.homeModules.fastfetch = _: {
    programs.fastfetch = {
      enable = true;
      settings = {
        logo = {
          type = "small";
        };
        display = {
          separator = ": ";
          key = {
            width = 12;
          };
        };
        modules = [
          "os"
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
					"gtk"
					"font"
          "terminal"
          {
            type = "cpu";
            format = "{name} ({cores-logical}) @ {freq-max}";
          }
          {
            type = "gpu";
            format = "{name}";
          }
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
