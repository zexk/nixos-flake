_: {
  flake.nixosModules.neovim =
    { pkgs, ... }:
    {
      programs.neovim = {
        enable = true;
        #package = inputs.neovim-nightly.packages.${pkgs.system}.default;
        defaultEditor = true;
        viAlias = true;
        configure = {
          customLuaRC = builtins.readFile ./init.lua;
          packages.myVimPackage = with pkgs.vimPlugins; {
            start = [
              mini-diff
              mini-git
              mini-pick
              mini-statusline
              blink-cmp
              blink-pairs
              kanagawa-nvim
              nvim-lspconfig
              oil-nvim
              snacks-nvim
              stay-centered-nvim
              opencode-nvim
              render-markdown-nvim
            ];
          };
        };
      };
    };
}
