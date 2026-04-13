{ inputs, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly.packages.${pkgs.system}.default;
    defaultEditor = true;
    viAlias = true;
    configure = {
      customLuaRC = builtins.readFile ./init.lua;
      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [
					mini-diff
					mini-git
					mini-statusline
          blink-cmp
          blink-pairs
          kanagawa-nvim
          mini-pick
          nvim-lspconfig
          oil-nvim
          snacks-nvim
          stay-centered-nvim
          aider-nvim  # <-- Added aider-nvim here
        ];
      };
    };
  };
}
