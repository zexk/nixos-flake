_: {
  flake.homeModules.claude = _: {
    programs.claude-code = {
      enable = true;

      enableMcpIntegration = true;

      settings = {
        theme = "dark";
        model = "claude-sonnet-4-6";
        includeCoAuthoredBy = false;

        permissions = {
          defaultMode = "acceptEdits";
        };
      };
    };
  };
}
