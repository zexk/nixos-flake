{ ... }:
{
  perSystem = { pkgs, ... }: {
    devShells.default = pkgs.mkShell {
      name = "nixos-flake";
      packages = with pkgs; [
        # LSP
        nixd

        # Linting
        statix

        # Dead code
        deadnix

        # Formatting (matches formatter output)
        nixfmt

        # Generation diffs
        nvd
      ];

      shellHook = ''
        echo ""
        echo " nixd     — language server (LSP)"
        echo " statix   — lint  (statix check . / statix fix .)"
        echo " deadnix  — dead code  (deadnix .)"
        echo " nixfmt   — format  (nixfmt **/*.nix)"
        echo " nvd      — generation diff  (nvd diff old new)"
        echo ""
      '';
    };
  };
}
