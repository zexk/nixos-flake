{
  flake.homeModules.aider-chat = {
    programs.aider-chat = {
      enable = true;

      settings = {
        openai-api-base = "http://127.0.0.1:8000/v1";
        openai-api-key = "not-needed";

        model = "openai/qwen2.5-coder-7b";
        weak-model = "openai/deepseek-r1-7b";
        editor-model = "openai/qwen2.5-coder-7b";

        architect = true;
        auto-accept-architect = false;
        check-model-accepts-settings = false;
        cache-prompts = true;
        show-model-warnings = false;

        dirty-commits = false;
        lint = true;
        dark-mode = true;
        verify-ssl = false;
      };
    };
  };
}
