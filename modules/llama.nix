{ inputs, ... }:
{
  flake.nixosModules.llama =
    { pkgs, lib, ... }:
    {
      services.llama-cpp = {
        enable = true;
        package = pkgs.llama-cpp-vulkan;
        modelsPreset = {
          "qwen3-6-27b" = {
            hf-repo = "bartowski/Qwen_Qwen3.6-27B-GGUF:IQ4_XS";
            alias = "qwen3-6-27b";
            n-predict = "-1";
            c = "32768";
            ngl = "999";
            temp = "0.6";
            top-p = "0.95";
            top-k = "20";
            min-p = "0.0";
            batch-size = "2048";
            ubatch-size = "512";
            repeat-penalty = "1.0";
            presence-penalty = "0.0";
            cache-type-k = "iq4_nl";
            cache-type-v = "iq4_nl";
            flash-attn = "on";
            jinja = "on";
          };
        };
      };
    };
}
