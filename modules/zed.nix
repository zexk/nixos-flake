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
            model = "gemma4-e4b";
          };
        };
        language_models = {
          openai_compatible = {
            "llama.cpp" = {
              api_url = "http://localhost:8080/v1";
              available_models = [
                {
                  name = "gemma4-e4b";
                  display_name = "Gemma 4 E4B";
                  max_tokens = 131072;
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
