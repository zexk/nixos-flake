_: {
  flake.homeModules.mcp =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      age.secrets.github = {
        file = ../secrets/github.age;
      };

      programs.mcp = {
        enable = true;
        servers = {
          # ── NixOS / nixpkgs ────────────────────────────────────────────────
          nixos = {
            command = lib.getExe pkgs.mcp-nixos;
            args = [ ];
          };

          # ── Filesystem ────────────────────────────────────────────────────
          filesystem = {
            command = lib.getExe pkgs.mcp-server-filesystem;
            args = [ config.home.homeDirectory ];
          };

          # ── GitHub ────────────────────────────────────────────────────────
          github = {
            command = toString (
              pkgs.writeShellScript "github-mcp" ''
                export GITHUB_PERSONAL_ACCESS_TOKEN=$(cat "${config.age.secrets.github.path}")
                exec ${lib.getExe pkgs.github-mcp-server} stdio --toolsets repos,issues,pull_requests,users
              ''
            );
            args = [ ];
          };

          # ── Context7 ──────────────────────────────────────────────────────
          context7 = {
            command = lib.getExe pkgs.context7-mcp;
            args = [ ];
          };
        };
      };
    };
}
