_:
{
  flake.homeModules.mcp =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      programs.mcp = {
        enable = true;
        servers = {
          # ── NixOS / nixpkgs ────────────────────────────────────────────────
          # Package search, option lookup, NixOS module docs
          nixos = {
            command = lib.getExe pkgs.mcp-nixos;
            args = [ ];
          };

          # ── Filesystem ────────────────────────────────────────────────────
          # Scoped read/write access; add more paths as needed
          filesystem = {
            command = lib.getExe pkgs.mcp-server-filesystem;
            args = [ config.home.homeDirectory ];
          };

          # ── Memory ────────────────────────────────────────────────────────
          # Persistent cross-session knowledge graph
          memory = {
            command = lib.getExe pkgs.mcp-server-memory;
            args = [ ];
          };

          # ── Sequential thinking ───────────────────────────────────────────
          # Structured multi-step reasoning and problem decomposition
          sequential-thinking = {
            command = lib.getExe pkgs.mcp-server-sequential-thinking;
            args = [ ];
          };

          # ── GitHub ────────────────────────────────────────────────────────
          # Repos, issues, PRs, code search, file access
          # Requires GITHUB_PERSONAL_ACCESS_TOKEN in the user environment
          github = {
            command = lib.getExe pkgs.github-mcp-server;
            args = [
              "--toolsets"
              "all"
            ];
          };

          # ── Context7 ──────────────────────────────────────────────────────
          # Up-to-date library / framework documentation for LLMs
          context7 = {
            command = lib.getExe pkgs.context7-mcp;
            args = [ ];
          };

          # ── Playwright ────────────────────────────────────────────────────
          # Headless browser: navigate pages, click, screenshot, extract text
          playwright = {
            command = lib.getExe pkgs.playwright-mcp;
            args = [ "--headless" ];
          };
        };
      };
    };
}
