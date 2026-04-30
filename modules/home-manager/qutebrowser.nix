{ ... }:
{
  flake.homeModules.qutebrowser = { ... }: {
    programs.qutebrowser = {
      enable = true;
      keyBindings = {
        normal = {
          " " = "spawn better-swallow mpv {url}";
          ",p" = "spawn --userscript qute-pass";
          "J" = "tab-prev";
          "K" = "tab-next";
        };
        prompt = {
          " " = "prompt-yes";
        };
      };
      searchEngines = {
        w = "https://en.wikipedia.org/wiki/Special:Search?search={}&go=Go&ns0=1";
        aw = "https://wiki.archlinux.org/?search={}";
        nw = "https://wiki.nixos.org/index.php?search={}";
        np = "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={}";
        no = "https://search.nixos.org/options?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={}";
      };
      settings = {
        colors = {
          statusbar = {
            normal = {
              bg = "#181616";
              fg = "#625e5a";
            };
            url = {
              fg = "#c5c9c5";
            };
            insert = {
              bg = "#87a987";
              fg = "#c5c9c5";
            };
          };
          tabs = {
            even = {
              bg = "#181616";
              fg = "#625e5a";
            };
            odd = {
              bg = "#181616";
              fg = "#625e5a";
            };
            selected = {
              even = {
                bg = "#938aa9";
                fg = "#c5c9c5";
              };
              odd = {
                bg = "#938aa9";
                fg = "#c5c9c5";
              };
            };
          };
          webpage.darkmode.enabled = true;
        };

        content.blocking.method = "both";

        fonts = {
          default_family = "Pixel Code Regular";
          default_size = "13.5pt";
        };

        scrolling = {
          bar = "never";
          smooth = true;
        };

        tabs = {
          indicator.width = 0;
          title = {
            format = "{current_title}";
          };
        };
      };
    };
  };
}
