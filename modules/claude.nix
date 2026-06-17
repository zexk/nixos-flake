{ inputs, ... }:
{
  flake.homeModules.claude =
    { pkgs, config, ... }:
    let
      claude-code = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-code;
    in
    {
      programs.claude-code = {
        enable = true;
        package = claude-code;

        enableMcpIntegration = true;

        settings = {
          theme = "dark";
          model = "claude-sonnet-4-6";
          advisorModel = "claude-opus-4-8";
          editorMode = "vim";
          showTurnDuration = true;
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
              "Bash(git status *)"
              "Bash(git diff *)"
              "Bash(git show *)"
              "Bash(git blame *)"
              "Bash(git add *)"
              "Bash(git commit *)"
              "Bash(git branch *)"
              "Bash(git stash *)"
              "Bash(git remote *)"
              "Bash(git fetch *)"
              # gh cli
              "Bash(gh *)"
              # filesystem read/query
              "Bash(ls *)"
              "Bash(find *)"
              "Bash(grep *)"
              "Bash(rg *)"
              "Bash(jq *)"
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
              "mcp__plugin_claude-code-home-manager_filesystem__list_directory_with_sizes"
              "mcp__plugin_claude-code-home-manager_filesystem__directory_tree"
              "mcp__plugin_claude-code-home-manager_filesystem__search_files"
              "mcp__plugin_claude-code-home-manager_filesystem__get_file_info"
              "mcp__plugin_claude-code-home-manager_filesystem__write_file"
              "mcp__plugin_claude-code-home-manager_filesystem__edit_file"
              "mcp__plugin_claude-code-home-manager_filesystem__create_directory"
              "mcp__plugin_claude-code-home-manager_filesystem__move_file"
              # mcp — memory graph
              "mcp__plugin_claude-code-home-manager_memory__read_graph"
              "mcp__plugin_claude-code-home-manager_memory__search_nodes"
              "mcp__plugin_claude-code-home-manager_memory__open_nodes"
              "mcp__plugin_claude-code-home-manager_memory__add_observations"
              "mcp__plugin_claude-code-home-manager_memory__create_entities"
              "mcp__plugin_claude-code-home-manager_memory__create_relations"
              "mcp__plugin_claude-code-home-manager_memory__delete_entities"
              "mcp__plugin_claude-code-home-manager_memory__delete_observations"
              "mcp__plugin_claude-code-home-manager_memory__delete_relations"
            ];
          };
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
      };
    };
}
