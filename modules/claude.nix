{ inputs, ... }:
{
  flake.homeModules.claude =
    { pkgs, ... }:
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
          editorMode = "vim";
          showTurnDuration = false;
          spinnerTipsEnabled = false;
          includeCoAuthoredBy = false;
          autoUpdaterStatus = "disabled";
          env.CLAUDE_CODE_ENABLE_AWAY_SUMMARY = "0";

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
            ];
          };
        };

        skills = {
          strip-em-dashes = ''
            ---
            name: strip-em-dashes
            description: Remove em dashes from README/CHANGELOG/docs prose and rewrite with plain punctuation. Use before the first commit that adds or rewrites a README or other prose doc, or when the user asks to clean up em dashes.
            ---

            # Strip em dashes

            Across zexk's repos, a README/LICENSE-adding commit is almost always
            followed by a separate "Remove em dash(es) from README" commit. Do this
            check up front instead of waiting for a correction.

            1. `grep -rn '\p{Pd}\|—' README.md CHANGELOG.md docs/ 2>/dev/null` (or just
               search for the literal em dash character) across any prose file you just
               wrote or edited.
            2. For each hit, replace the em dash with the punctuation it's actually
               standing in for: comma, period + new sentence, colon, or parentheses.
               Pick based on what reads naturally, don't just delete the dash.
            3. Re-read the resulting sentence to confirm it still flows.
            4. Never introduce a new em dash when writing README/CHANGELOG/commit-message
               prose in the first place.
          '';

          repo-release-prep = ''
            ---
            name: repo-release-prep
            description: Prepare a project repo for its first public commit — README, LICENSE, and a gitignore for build artifacts. Use when starting a new repo, or when the user asks to finalize/polish a repo before pushing it.
            ---

            # Repo release prep

            zexk's repos converge on the same short checklist before the first real
            commit or push:

            1. **README.md** — project name, one-line description, build/run
               instructions matching the actual flake/build system in the repo. Run
               [[strip-em-dashes]]-style cleanup before committing (no em dashes).
            2. **LICENSE** — default to MIT unless told otherwise. First check whether
               a bundled asset already carries its own license (e.g. a font under
               OFL.txt) — don't drop a conflicting top-level LICENSE on top of it; ask
               which license actually applies to the repo as a whole.
            3. **.gitignore** — cover this language's build output before it gets
               committed: `result` (nix build symlink), `build/`, `zig-cache/`,
               `zig-out/`, `*.o`, `node_modules/`, `__pycache__/`, `.pre-commit-config.yaml`
               (auto-generated), etc. Run `git status` first — if build artifacts are
               already tracked, `git rm --cached` them in the same commit.
            4. Commit these together (matches existing convention: "Add README,
               LICENSE, and stop tracking build artifacts").
          '';

          flake-devshell-init = ''
            ---
            name: flake-devshell-init
            description: Scaffold a flake.nix with a devShell (and usually a package output) for a new project. Use when a repo has no flake.nix yet and needs a reproducible nix dev environment, or when asked to add one.
            ---

            # Flake devShell scaffold

            zexk's project repos (as opposed to this NixOS config, which uses
            flake-parts) use a plain `flake-utils.lib.eachDefaultSystem` or hand-rolled
            `forAllSystems` shape:

            ```nix
            {
              description = "<one-line project description>";

              inputs = {
                nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
                flake-utils.url = "github:numtide/flake-utils";
              };

              outputs = { self, nixpkgs, flake-utils }:
                flake-utils.lib.eachDefaultSystem (system:
                  let
                    pkgs = nixpkgs.legacyPackages.''${system};
                  in {
                    devShells.default = pkgs.mkShell {
                      packages = with pkgs; [ /* toolchain */ ];
                      shellHook = "echo dev shell ready";
                    };

                    packages.default = pkgs.stdenv.mkDerivation {
                      pname = "<name>";
                      version = "0.1.0";
                      src = ./.;
                      # nativeBuildInputs / buildInputs / installPhase as needed
                    };

                    formatter = pkgs.nixpkgs-fmt;
                  });
            }
            ```

            Pick the toolchain packages for the language actually in the repo (gcc +
            gnumake for C, zig + zls for Zig, go, rustc + cargo, python3, etc.) — mirror
            what's already used in sibling repos (kiln, zetui, dmenu, qmk_userspace) for
            the same language rather than inventing new conventions. If the project
            depends on another of zexk's own flakes (e.g. kiln), pin it as a flake
            input with `inputs.nixpkgs.follows = "nixpkgs"` and leave a comment on how
            to update it (`nix flake update <input>`).
          '';

          sync-agents-docs = ''
            ---
            name: sync-agents-docs
            description: Update AGENTS.md/README after a refactor, module rename, or architecture change so agent-facing docs match reality. Use after any change that alters build steps, module/file layout, or renames a core concept.
            ---

            # Sync AGENTS.md / README after a refactor

            In zexk's C/game-engine repos (kiln, kyub) architecture or module-layout
            changes are consistently followed by a doc-sync commit ("docs: sync
            AGENTS/README with ... architecture"). Do this in the same change instead
            of as a follow-up:

            1. After renaming a module/binary, changing the build graph, or
               restructuring how a subsystem works, re-read AGENTS.md and README.md in
               the repo root.
            2. Update any build commands, file paths, or subsystem names they mention
               to match the new reality — stale build instructions are worse than none.
            3. Keep the same terse, command-first style already used in that repo's
               AGENTS.md (build commands in fenced shell blocks, no prose padding).
          '';
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

          Local LLM: llama.cpp (Vulkan) at localhost:1135 — qwen3-6-27b MTP IQ4_XS
          AI tools on same endpoint: opencode (qwen3-6-27b) · aider (qwen2.5-coder-7b) · zed (qwen3-6-27b)
          SSH via gpg-agent (gnupg with enableSSHSupport)
          Web: zexk.xyz → Caddy serving /srv/http via Cloudflare tunnel

          MCP servers (pre-approved, use proactively):
          - nixos      → packages, options (always prefer over web search for nix)
          - context7   → up-to-date library docs
          - filesystem → read/write under ~/
          - github     → repos, PRs, issues

          Be concise. No post-action summaries. No unchanged file sections in edits.
          No "I will now X" — just do it.
        '';
      };
    };
}
