_: {
  flake.homeModules.neovim =
    { pkgs, ... }:
    {
      programs.neovim = {
        enable = true;
        #package = inputs.neovim-nightly.packages.${pkgs.system}.default;
        defaultEditor = true;
        viAlias = true;
        extraLuaConfig = builtins.readFile ./init.lua;
        plugins = with pkgs.vimPlugins; [
          mini-diff
          mini-git
          mini-pick
          mini-statusline
          blink-cmp
          blink-pairs
          nvim-lspconfig
          oil-nvim
          snacks-nvim
          stay-centered-nvim
          opencode-nvim
          render-markdown-nvim
        ];
      };
    };
}
