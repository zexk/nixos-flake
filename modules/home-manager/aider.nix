{ ... }:
{
  flake.homeModules.aider = { ... }: {
    programs.aider-chat = {
      enable = true;
      settings = {
        model = "openai/gemma-4-e4b";
        openai-api-base = "http://127.0.0.1:8080/v1";
        openai-api-key = "MOCK";
        dark-mode = true;
        dirty-commits = false;
        show-model-warnings = false;
      };
    };
  };
}
