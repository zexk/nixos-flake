_: {
  flake.homeModules.neovim =
    { pkgs, ... }:
    {
      programs.neovim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        withRuby = false;
        withPython3 = false;
        initLua = builtins.readFile ./init.lua;
        plugins = with pkgs.vimPlugins; [
          nvim-treesitter.withAllGrammars
          mini-diff
          fff-nvim
          oil-nvim
          blink-cmp
          blink-pairs
          nvim-lspconfig
          snacks-nvim
          mini-statusline
          stay-centered-nvim
          opencode-nvim
          render-markdown-nvim
          luasnip
        ];
      };
    };
}
