{ ... }:
{
  flake.homeModules.mcp = { ... }: {
    programs.mcp = {
      enable = true;
      servers = {
        nixos = {
          command = "mcp-nixos";
          args = [ ];
        };
      };
    };
  };
}
