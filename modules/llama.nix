{
  flake.nixosModules.llama =
    { pkgs, lib, ... }:
    {
      services.llama-cpp = {
        enable = true;
        package = pkgs.llama-cpp-vulkan;

        modelsPreset = {
          # Primary: agentic coding
          "qwen3-coder-25b" = {
            hf-repo = "bartowski/cerebras_Qwen3-Coder-REAP-25B-A3B-GGUF:IQ4_NL";
            alias = "qwen3-coder-25b";
            n-predict = "-1";
            c = "32768";
            ngl = "999";
            temp = "0.6";       # Qwen3 recommended default
            top-p = "0.95";     # Qwen3 recommended default
            top-k = "20";       # Qwen3 recommended default
            min-p = "0.0";
            repeat-penalty = "1.0";   # Qwen3 docs: keep at 1.0, avoid >1.1
            presence-penalty = "1.5"; # Qwen3 recommended to reduce repetition
            flash-attn = "on";
            cache-type-k = "q8_0";   # quantized KV saves ~20% VRAM headroom
            cache-type-v = "q8_0";
            jinja = "on";            # required for Qwen3 tool calling
          };

          # Fallback: vision / audio / general tasks
          "gemma-4-e4b" = {
            hf-repo = "bartowski/google_gemma-4-E4B-it-GGUF:Q8_0";
            alias = "gemma-4-e4b";
            n-predict = "-1";
            c = "32768";
            ngl = "999";
            temp = "1.0";       # Gemma 4 recommended default
            top-p = "0.95";
            top-k = "64";       # Gemma 4 recommended default
            min-p = "0.0";
            repeat-penalty = "1.0";
            presence-penalty = "0.0";
            flash-attn = "on";
            cache-type-k = "q8_0";
            cache-type-v = "q8_0";
            jinja = "on";
          };
        };
      };
    };
}
