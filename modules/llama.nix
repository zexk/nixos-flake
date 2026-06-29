{ ... }:
{
  flake.nixosModules.llama =
    { pkgs, ... }:
    let
      # Router mode: model is loaded on first request, not at server startup.
      # Keeps ~13GB VRAM free until the LLM is actually polled.
      modelPreset = pkgs.writeText "llama-models.ini" ''
        [qwen3-6-27b]
        model = /var/llm/Qwen3.6-27B-IQ4_XS.gguf
        alias = qwen3-6-27b
        n-predict = -1
        c = 32768
        gpu-layers = 999
        temp = 0.6
        top-p = 0.95
        top-k = 20
        min-p = 0.0
        batch-size = 2048
        ubatch-size = 256
        repeat-penalty = 1.0
        presence-penalty = 0.0
        cache-type-k = q8_0
        cache-type-v = q8_0
        flash-attn = on
        jinja = on
        spec-type = draft-mtp
        spec-draft-n-max = 2
      '';
    in
    {
      services.llama-cpp = {
        enable = true;
        package = pkgs.llama-cpp-vulkan;
        settings = {
          host = "127.0.0.1";
          port = 1135;
          models-preset = modelPreset;
        };
      };
    };
}
