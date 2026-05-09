{ inputs, ... }:
{
  flake.homeModules.opencode =
    { pkgs, ... }:
    let
      opencode = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.opencode;
    in
    {
      programs.opencode = {
        enable = true;
        package = opencode;
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
          model = "llamacpp/gemma4-e4b";
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
                "gemma4-e4b" = {
                  name = "Gemma 4 E4B";
                  contextLength = 131072;
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
