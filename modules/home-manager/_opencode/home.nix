{
  programs.opencode = {
    enable = true;
    enableMcpIntegration = true;
    skills = ./skills;
    settings = {
      model = "llama-cpp/gemma-4-e4b";
      provider = {
        "llama-cpp" = {
          name = "llama.cpp (local)";
          npm = "@ai-sdk/openai-compatible";
          options = {
            baseURL = "http://127.0.0.1:8080/v1";
          };
          models = {
            "gemma-4-e4b" = {
              name = "gemma 4";
              limit = {
                context = 128000;
                output = 65536;
              };
            };
          };
        };
      };
    };
    tui = {
      theme = "system";
    };
  };
}
