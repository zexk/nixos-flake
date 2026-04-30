_:
{
  perSystem =
    { pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        name = "nixos-flake";
        packages = with pkgs; [
          nixd
          statix
          deadnix
          nixfmt
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
