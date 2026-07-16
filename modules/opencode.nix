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
          - context7: fetch up-to-date library documentation
          - nixos: query NixOS options and packages
        '';
        settings = {
          lsp = true;
          model = "llamacpp/qwen3-6-27b";
          provider = {
            llamacpp = {
              options = {
                baseURL = "http://localhost:1135/v1";
                apiKey = "not-needed";
                toolParser = [
                  { type = "raw-function-call"; }
                  { type = "json"; }
                ];
              };
              models = {
                "qwen3-6-27b" = {
                  name = "Qwen3 6-27B";
                  contextLength = 65536;
                };
              };
            };
          };
          autoshare = false;
          autoupdate = false;
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
