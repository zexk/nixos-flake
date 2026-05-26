_: {
  flake.homeModules.claude =
    { config, ... }:
    {
      programs.claude-code = {
        enable = true;

        enableMcpIntegration = true;

        settings = {
          theme = "dark";
          model = "claude-sonnet-4-6";
          includeCoAuthoredBy = false;
          autoUpdaterStatus = "disabled";

          permissions = {
            defaultMode = "acceptEdits";
            allow = [
              # nix
              "Bash(nix eval *)"
              "Bash(nix build *)"
              "Bash(nix flake *)"
              "Bash(nix fmt *)"
              "Bash(statix check *)"
              "Bash(deadnix *)"
              "Bash(nh *)"
              # git
              "Bash(git log *)"
              "Bash(git status)"
              "Bash(git diff *)"
              "Bash(git show *)"
              "Bash(git blame *)"
              "Bash(git add *)"
              "Bash(git commit *)"
              # filesystem read
              "Bash(ls *)"
              "Bash(find *)"
              "Bash(grep *)"
              # mcp — nixos / docs
              "mcp__plugin_claude-code-home-manager_nixos__nix"
              "mcp__plugin_claude-code-home-manager_nixos__nix_versions"
              "mcp__plugin_claude-code-home-manager_context7__resolve-library-id"
              "mcp__plugin_claude-code-home-manager_context7__query-docs"
              # mcp — filesystem (home-scoped)
              "mcp__plugin_claude-code-home-manager_filesystem__read_file"
              "mcp__plugin_claude-code-home-manager_filesystem__read_multiple_files"
              "mcp__plugin_claude-code-home-manager_filesystem__read_text_file"
              "mcp__plugin_claude-code-home-manager_filesystem__list_directory"
              "mcp__plugin_claude-code-home-manager_filesystem__directory_tree"
              "mcp__plugin_claude-code-home-manager_filesystem__search_files"
              "mcp__plugin_claude-code-home-manager_filesystem__write_file"
              "mcp__plugin_claude-code-home-manager_filesystem__edit_file"
              # mcp — memory graph
              "mcp__plugin_claude-code-home-manager_memory__read_graph"
              "mcp__plugin_claude-code-home-manager_memory__search_nodes"
              "mcp__plugin_claude-code-home-manager_memory__open_nodes"
              "mcp__plugin_claude-code-home-manager_memory__add_observations"
              "mcp__plugin_claude-code-home-manager_memory__create_entities"
              "mcp__plugin_claude-code-home-manager_memory__create_relations"
            ];
          };

          # Hook events are top-level keys in settings.json
          PostToolUse = [
            {
              matcher = "Edit|Write";
              hooks = [
                {
                  type = "command";
                  command = "${config.home.homeDirectory}/.claude/hooks/fmt-nix";
                  timeout = 10;
                }
              ];
            }
          ];
        };

        context = ''
          # nixos-flake

          flake-parts + import-tree; ./modules/ auto-imported. Each file exports
          flake.homeModules.<name> or flake.nixosModules.<name>. Prefix _ to disable.
          All homeModules apply to user zexk on host kuwadorian.

          Module skeleton:
          ```nix
          _: { flake.homeModules.name = { pkgs, lib, config, ... }: { ... }; }
          ```

          Inputs: nixpkgs (unstable) · home-manager · oxwm (own fork) · umbra · agenix · llm-agents
          DevShell (enter with `nix develop`): nixd · statix · deadnix · nixfmt · nvd
          Format: `nix fmt <file>` (traverses up to flake.nix; also `./format.sh` for all files)
          Rebuild: `nh os switch .` (flake path is pre-configured in nh; works from anywhere)
          Secrets: agenix — add to secrets/secrets.nix, encrypt with `age`, reference in modules

          Stack: oxwm (X11 tiling, Mod4) · alacritty (PxPlus IBM VGA font) · bash+starship
                 neovim (default editor, Space leader, mini.*/blink-cmp/oil/snacks)
                 zed (vim mode, local llama.cpp) · tmux (prefix s, vi keys) · lazygit · gh
                 qutebrowser (secondary) · chromium (default for web MIME)
                 fzf · zoxide (replaces cd) · bat · pass (password-store) · mpd

          Local LLM: llama.cpp (Vulkan) at localhost:8080 — qwen3-6-27b MTP IQ4_XS
          AI tools on same endpoint: opencode (qwen3-8b) · aider (qwen2.5-coder-7b) · zed (gemma4-e4b)
          SSH via gpg-agent (gnupg with enableSSHSupport)
          Web: zexk.xyz → Caddy serving /srv/http via Cloudflare tunnel

          MCP servers (pre-approved, use proactively):
          - nixos      → packages, options (always prefer over web search for nix)
          - context7   → up-to-date library docs
          - filesystem → read/write under ~/
          - memory     → persist facts across sessions
          - github     → repos, PRs, issues
          - sequential-thinking → complex multi-step planning

          Be concise. No post-action summaries. No unchanged file sections in edits.
          No "I will now X" — just do it.
        '';

        # fmt-nix: format + lint .nix files after every Edit/Write
        # `nix fmt <file>` finds the nearest flake.nix — no devShell required
        # statix guarded since it lives only in the devShell
        hooks = {
          fmt-nix = ''
            #!/usr/bin/env bash
            file=$(python3 -c "
            import sys, json
            d = json.load(sys.stdin)
            print(d.get(\"tool_input\", {}).get(\"file_path\", \"\"))
            " 2>/dev/null)
            [[ "$file" != *.nix ]] && exit 0
            nix fmt "$file" 2>/dev/null
            command -v statix &>/dev/null && statix check "$file" 2>/dev/null
            exit 0
          '';
        };
      };
    };
}
