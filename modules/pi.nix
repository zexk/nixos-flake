{ inputs, ... }:
{
  flake.homeModules.pi =
    { pkgs, config, ... }:
    let
      pi = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.pi;
    in
    {
      home.packages = [
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
