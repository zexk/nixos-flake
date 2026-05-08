{ inputs, ... }:
{
  flake.homeModules.pi =
    { pkgs, config, ... }:
    let
      pi = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.pi;
      cp-cli = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.copilot-cli;
      codex = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codex;
      gemini-cli = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.gemini-cli;
      qwen-code = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.qwen-code;
    in
    {
      home.packages = [
				cp-cli
				codex
				gemini-cli
				qwen-code
        pkgs.nodejs_latest
        (pkgs.symlinkJoin {
          name = "pi";
          buildInputs = [ pkgs.makeWrapper ];
          paths = [ pi ];
          postBuild = ''
            wrapProgram $out/bin/pi \
              --set NPM_CONFIG_PREFIX "${config.home.homeDirectory}/.pi/npm" \
              --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.nodejs_latest ]}
          '';
        })
      ];
    };
}
