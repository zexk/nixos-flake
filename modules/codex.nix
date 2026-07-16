{ inputs, ... }:
{
  flake.homeModules.codex =
    { pkgs, ... }:
    let
      codex = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codex;
    in
    {
      programs.codex = {
        enable = true;
        package = codex;
        enableMcpIntegration = true;
      };
    };
}
