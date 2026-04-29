{
  programs.opencode = {
    enable = true;
    enableMcpIntegration = true;
    settings = {
      model = "gemma-4-e4b";
      model_provider = "llama-cpp";
      model_providers = {
        llama-cpp = {
          name = "llama-cpp";
          baseURL = "http://localhost:8080/v1";
          apiKey = "LLAMA_API_KEY";
        };
      };
    };
  };
}
