_: {
  perSystem =
    { pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        name = "nixos-flake";
        packages = with pkgs; [
          # repo management
          git
          gh
          lazygit
          delta

          # language servers
          nil
          lua-language-server
          pyright
          rust-analyzer
          marksman
          taplo
          yaml-language-server
          bash-language-server

          # nix tooling
          nixd
          statix
          deadnix
          nixfmt
          nvd
          nix-output-monitor

          # checkers & formatters
          shellcheck
          shfmt
          typos
          treefmt

          # utilities
          ripgrep
          fd
          jq
          yq
          comma
        ];

        shellHook = ''
          echo ""
          echo "  repo management: git, gh, lazygit, delta"
          echo "  LSPs:            nil, lua-language-server, pyright, rust-analyzer,"
          echo "                   marksman, taplo, yaml-language-server, bash-language-server"
          echo "  nix tooling:     nixd, statix, deadnix, nixfmt, nvd, nom"
          echo "  checkers:        shellcheck, shfmt, typos, treefmt"
          echo "  utilities:       rg, fd, jq, yq, comma"
          echo ""
        '';
      };
    };
}
