_: {
  flake.homeModules.zed = _: {
    programs.zed-editor = {
      enable = true;
      enableMcpIntegration = true;
      extensions = [
        "nix"
        "toml"
      ];
      userSettings = {
        vim_mode = true;
        ui_font_size = 16;
        buffer_font_size = 24;
        load_direnv = "shell_hook";
        agent = {
          version = "2";
          default_model = {
            provider = "llama.cpp";
            model = "qwen3-6-27b";
          };
        };
        language_models = {
          openai_compatible = {
            "llama.cpp" = {
              api_url = "http://localhost:1135/v1";
              available_models = [
                {
                  name = "qwen3-6-27b";
                  display_name = "Qwen3 6-27B";
                  max_tokens = 32768;
                  capabilities = {
                    tools = true;
                    images = false;
                    parallel_tool_calls = false;
                    prompt_cache_key = false;
                    chat_completions = true;
                  };
                }
              ];
            };
          };
        };
      };
    };
  };
}
