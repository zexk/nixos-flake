_: {
  flake.homeModules.opencode =
    { pkgs, ... }:
    {
      programs.opencode = {
        enable = true;
				context = ''
					Be concise. Do not repeat file contents back in responses.
    			Do not summarize what you just did after doing it.
    			Do not include unchanged file sections in edits.
					You have access to MCP servers. Use them proactively:
    			- filesystem: read/write files outside the project
    			- github: interact with GitHub repos, PRs, issues
    			- memory: persist information across sessions
    			- context7: fetch up-to-date library documentation
    			- nixos: query NixOS options and packages
    			- sequential-thinking: use for complex multi-step planning
				'';
        settings = {
          model = "llamacpp/qwen3-coder-25b";
          provider = {
            llamacpp = {
              options = {
                baseURL = "http://localhost:8080/v1";
                apiKey = "not-needed";
								toolParser = [
          				{ type = "raw-function-call"; }
          				{ type = "json"; }
        				];
              };
              models = {
                "qwen3-coder-25b" = {
                  name = "Qwen3 Coder REAP 25B";
                };
                "gemma-4-e4b" = {
                  name = "Gemma 4 E4B";
                };
              };
            };
          };
          autoshare = false;
          autoupdate = false;
					compaction.threshold = 0.7;
        };
        tui = {
          theme = "system";
        };
        enableMcpIntegration = true;
        web = {
          enable = true;
        };
      };
    };
}
