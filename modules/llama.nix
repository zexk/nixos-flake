{ inputs, ... }:
{
  flake.nixosModules.llama =
    { pkgs, lib, ... }:
    {
      services.llama-cpp = {
        enable = true;
        package = pkgs.llama-cpp-vulkan;
        modelsPreset = {
          "qwen3-8b" = {
            hf-repo = "bartowski/Qwen_Qwen3-8B-GGUF:Q6_K";
            alias = "qwen3-8b";
            n-predict = "-1";
            c = "65536";
            ngl = "999";
            temp = "0.6";
            top-p = "0.95";
            top-k = "20";
            min-p = "0.0";
            batch-size = "4096";
            ubatch-size = "4096";
            repeat-penalty = "1.0";
            presence-penalty = "0.0";
            cache-type-k = "q8_0";
            cache-type-v = "q8_0";
            flash-attn = "on";
            jinja = "on";
          };
        };
      };
    };
}
