{ self, ... }:
{
  flake.homeModules.llm-optimize =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.programs.llm-optimize;

      npinsSources = import cfg.sourcesPath;

      getPinnedSource =
        name:
        if builtins.hasAttr name npinsSources then
          let
            source = builtins.getAttr name npinsSources;
          in
          if builtins.isAttrs source && source ? outPath then source.outPath else source
        else
          throw ''
            programs.llm-optimize requires an npins pin named `${name}`.

            Add it from the root of the configuration repository, for example:

              npins add github <owner> <repository> --name ${name} -b main
          '';

      cavemanSource = getPinnedSource "caveman";
      ponytailSource = getPinnedSource "ponytail";

      rtkPackage =
        pkgs.rtk
          or (throw "programs.llm-optimize.rtk.enable requires pkgs.rtk from a recent nixpkgs revision");

      # Claude Code and current Codex accept the same PreToolUse updatedInput
      # response shape. Keep this hook fail-open: any parsing or rewrite failure
      # leaves the original command untouched.
      #
      # `rtk rewrite` exits 0 for a plain rewrite and 3 when the rewrite is
      # flagged (pipes, `;` chains, lossy `cat` -> `rtk read`). Exit 3 covers
      # most real commands, so skipping it makes the hook a near-total no-op;
      # pass --allow-flagged to accept those too.
      rtkRewriteHook = pkgs.writeShellApplication {
        name = "llm-optimize-rtk-rewrite";
        runtimeInputs = [
          pkgs.jq
          rtkPackage
        ];
        text = ''
          input="$(${pkgs.coreutils}/bin/cat)"
          command="$(${pkgs.jq}/bin/jq -r '.tool_input.command // empty' <<<"$input" 2>/dev/null || true)"

          [[ -n "$command" ]] || exit 0

          set +e
          rewritten="$(${lib.getExe rtkPackage} rewrite "$command" 2>/dev/null)"
          status=$?
          set -e

          case "$status" in
            0) ;;
            3)
              [[ "''${1:-}" == "--allow-flagged" ]] || exit 0
              ;;
            *)
              exit 0
              ;;
          esac

          [[ -n "$rewritten" && "$rewritten" != "$command" ]] || exit 0

          # Codex accepts permissionDecision:allow only when updatedInput is
          # present. Build the response from scratch and validate it before
          # printing, so this hook can never emit a naked allow decision.
          output="$(${pkgs.jq}/bin/jq -cn \
            --arg command "$rewritten" \
            '{
              hookSpecificOutput: {
                hookEventName: "PreToolUse",
                permissionDecision: "allow",
                permissionDecisionReason: "RTK auto-rewrite",
                updatedInput: { command: $command }
              }
            }' 2>/dev/null || true)"

          ${pkgs.jq}/bin/jq -e '
            (.hookSpecificOutput.permissionDecision == "allow")
            and (.hookSpecificOutput.updatedInput | type == "object")
            and (.hookSpecificOutput.updatedInput.command | type == "string" and length > 0)
          ' <<<"$output" >/dev/null 2>&1 || exit 0

          printf '%s\n' "$output"
        '';
      };

      mkRtkHook = args: {
        matcher = "^Bash$";
        hooks = [
          {
            type = "command";
            command = lib.concatStringsSep " " ([ (lib.getExe rtkRewriteHook) ] ++ args);
            timeout = 10;
            statusMessage = "Compressing command output with RTK";
          }
        ];
      };

      # Ponytail's own UserPromptSubmit hook only reinforces on native Claude
      # when a /ponytail command is typed (unlike Caveman, which re-emits its
      # rule every turn). Without a compaction event in between, the ladder
      # discipline only ever gets stated once at SessionStart and can drift
      # out of the model's attention over a long session. Upstream considered
      # this (ponytail PR #77) but closed it unmerged, so patch it in here.
      ponytailReminderHook = pkgs.writeShellApplication {
        name = "llm-optimize-ponytail-reminder";
        runtimeInputs = [
          pkgs.coreutils
          pkgs.jq
        ];
        text = ''
          cat >/dev/null
          state_dir="''${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
          mode="$(${pkgs.coreutils}/bin/cat "$state_dir/.ponytail-active" 2>/dev/null || true)"

          [[ -n "$mode" ]] || exit 0

          ${pkgs.jq}/bin/jq -cn --arg mode "$mode" '{
            hookSpecificOutput: {
              hookEventName: "UserPromptSubmit",
              additionalContext: ("PONYTAIL MODE ACTIVE — level: " + $mode + ". Apply the ladder: YAGNI, reuse, stdlib, shortest diff.")
            }
          }'
        '';
      };

      # Caveman's upstream Claude hook scripts already implement mode parsing,
      # persistence, per-turn reinforcement, and SKILL.md filtering. These small
      # adapters provide the environment and output conventions expected by
      # Codex while keeping the behavior sourced from the pinned Caveman tree.
      cavemanCodexSessionStart = pkgs.writeShellApplication {
        name = "llm-optimize-caveman-codex-session-start";
        runtimeInputs = [
          pkgs.coreutils
          pkgs.nodejs
        ];
        text = ''
          # Codex supplies a JSON payload on stdin. Caveman's activation hook
          # does not need it, but consume it so the pipe closes cleanly.
          cat >/dev/null

          umask 077
          state_dir="''${XDG_STATE_HOME:-$HOME/.local/state}/llm-optimize/caveman-codex"
          mkdir -p "$state_dir"

          # Suppress Caveman's Claude-only statusline setup nudge. Runtime mode
          # state still lives in this writable directory.
          printf '%s\n' '{"statusLine":true}' > "$state_dir/settings.json"

          export CLAUDE_CONFIG_DIR="$state_dir"
          export CLAUDE_PLUGIN_ROOT=${lib.escapeShellArg (toString cavemanSource)}

          exec ${lib.getExe pkgs.nodejs} \
            ${lib.escapeShellArg (toString (cavemanSource + "/src/hooks/caveman-activate.js"))}
        '';
      };

      cavemanCodexPromptSubmit = pkgs.writeShellApplication {
        name = "llm-optimize-caveman-codex-prompt-submit";
        runtimeInputs = [
          pkgs.coreutils
          pkgs.jq
          pkgs.nodejs
        ];
        text = ''
          umask 077
          state_dir="''${XDG_STATE_HOME:-$HOME/.local/state}/llm-optimize/caveman-codex"
          mkdir -p "$state_dir"

          export CLAUDE_CONFIG_DIR="$state_dir"
          export CLAUDE_PLUGIN_ROOT=${lib.escapeShellArg (toString cavemanSource)}

          input="$(cat)"

          # Caveman currently recognizes slash commands. Codex may surface a
          # skill as @caveman or $caveman, so normalize only that leading token.
          normalized="$(${lib.getExe pkgs.jq} -c '
            if (.prompt? | type) == "string" then
              .prompt |= sub("^[@$]caveman(?=(:|[-[:space:]]|$))"; "/caveman")
            else
              .
            end
          ' <<<"$input" 2>/dev/null || printf '%s' "$input")"

          printf '%s' "$normalized" | exec ${lib.getExe pkgs.nodejs} \
            ${lib.escapeShellArg (toString (cavemanSource + "/src/hooks/caveman-mode-tracker.js"))}
        '';
      };

      cavemanCodexSessionStartHook = {
        hooks = [
          {
            type = "command";
            command = lib.getExe cavemanCodexSessionStart;
            timeout = 10;
            statusMessage = "Activating Caveman mode";
          }
        ];
      };

      cavemanCodexPromptSubmitHook = {
        hooks = [
          {
            type = "command";
            command = lib.getExe cavemanCodexPromptSubmit;
            timeout = 10;
            statusMessage = "Applying Caveman mode";
          }
        ];
      };
    in
    {
      options.programs.llm-optimize = {
        enable = lib.mkEnableOption "the Caveman, Ponytail, and RTK agent optimization stack" // {
          default = true;
        };

        sourcesPath = lib.mkOption {
          type = lib.types.path;
          default = self + /npins;
          defaultText = lib.literalExpression "self + /npins";
          description = "Directory generated by npins containing default.nix and sources.json.";
        };

        caveman = {
          enable = lib.mkEnableOption "always-on concise agent responses" // {
            default = true;
          };

          defaultMode = lib.mkOption {
            type = lib.types.enum [
              "lite"
              "full"
              "ultra"
              "wenyan-lite"
              "wenyan"
              "wenyan-full"
              "wenyan-ultra"
            ];
            default = "full";
            description = "Caveman mode activated at the start of each agent session.";
          };
        };

        ponytail = {
          enable = lib.mkEnableOption "minimal, YAGNI-oriented implementation decisions" // {
            default = true;
          };

          defaultMode = lib.mkOption {
            type = lib.types.enum [
              "lite"
              "full"
              "ultra"
              "off"
            ];
            default = "full";
            description = "Ponytail mode activated at the start of each agent session.";
          };
        };

        rtk.enable = lib.mkEnableOption "transparent shell-output reduction through RTK" // {
          default = true;
        };
      };

      config = lib.mkIf cfg.enable {
        assertions = [
          {
            assertion = !cfg.rtk.enable || pkgs ? rtk;
            message = "programs.llm-optimize.rtk.enable requires pkgs.rtk from a recent nixpkgs revision";
          }
        ];

        home.packages =
          lib.optionals (cfg.caveman.enable || cfg.ponytail.enable) [ pkgs.nodejs ]
          ++ lib.optionals cfg.rtk.enable [ rtkPackage ];

        # Both plugins resolve their startup mode from these variables before
        # consulting mutable user or project state. Session commands can still
        # switch modes without a Home Manager rebuild.
        home.sessionVariables =
          lib.optionalAttrs cfg.caveman.enable {
            CAVEMAN_DEFAULT_MODE = cfg.caveman.defaultMode;
          }
          // lib.optionalAttrs cfg.ponytail.enable {
            PONYTAIL_DEFAULT_MODE = cfg.ponytail.defaultMode;
          }
          // lib.optionalAttrs cfg.rtk.enable {
            RTK_TELEMETRY_DISABLED = "1";
          };

        programs.claude-code = {
          # Both ship a real .claude-plugin/plugin.json (hooks, skills,
          # commands together); loading them as personal plugins keeps this
          # in sync with upstream instead of hand-copying each hook entry.
          plugins =
            lib.optionals cfg.caveman.enable [ cavemanSource ]
            ++ lib.optionals cfg.ponytail.enable [ ponytailSource ];

          settings.hooks = {
            # Ponytail's plugin hook only reinforces on native Claude when a
            # /ponytail command is typed; Caveman re-emits its rule every
            # turn. Without that, ladder discipline is only stated once at
            # SessionStart and can drift out of context over a long session.
            # Upstream considered this (ponytail PR #77) but closed it
            # unmerged, so patch it in here.
            UserPromptSubmit = lib.mkIf cfg.ponytail.enable (
              lib.mkAfter [
                {
                  hooks = [
                    {
                      type = "command";
                      command = lib.getExe ponytailReminderHook;
                      timeout = 5;
                      statusMessage = "Reinforcing ponytail mode";
                    }
                  ];
                }
              ]
            );
            PreToolUse = lib.mkIf cfg.rtk.enable (lib.mkAfter [ (mkRtkHook [ "--allow-flagged" ]) ]);
          };

          # Only Caveman ships a statusline script; without it there is no
          # visible indication that the mode is active.
          settings.statusLine = lib.mkIf cfg.caveman.enable {
            type = "command";
            command = "${lib.getExe pkgs.bash} ${
              lib.escapeShellArg (toString (cavemanSource + "/src/hooks/caveman-statusline.sh"))
            }";
          };
        };

        # The custom codex.nix module remains responsible for keeping
        # config.toml mutable and merging these declarations into it.
        programs.codex = {
          plugins = lib.mkAfter (
            lib.optionals cfg.caveman.enable [ cavemanSource ]
            ++ lib.optionals cfg.ponytail.enable [ ponytailSource ]
          );

          hooks = {
            SessionStart = lib.mkIf cfg.caveman.enable (lib.mkAfter [ cavemanCodexSessionStartHook ]);

            UserPromptSubmit = lib.mkIf cfg.caveman.enable (lib.mkAfter [ cavemanCodexPromptSubmitHook ]);

            # No --allow-flagged here: RTK exit 3 marks rewrites that change
            # output semantics, and Codex rejects permissionDecision:ask, so
            # there is no way to surface that to the user.
            PreToolUse = lib.mkIf cfg.rtk.enable (lib.mkAfter [ (mkRtkHook [ ]) ]);
          };
        };
      };
    };
}
