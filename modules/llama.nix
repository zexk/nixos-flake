{ inputs, ... }:
{
  flake.nixosModules.llama =
    { pkgs, lib, ... }:
    {
      services.llama-cpp = {
        enable = true;
        package = pkgs.llama-cpp-vulkan;
        modelsPreset = {
          "gemma-e4b" = {
            hf-repo = "unsloth/gemma-4-E4B-it-GGUF:UD-Q4_K_XL";
            alias = "gemma4-e4b";
            n-predict = "-1";
            c = "131072";
            ngl = "999";
            temp = "1.0";
            top-p = "0.95";
            top-k = "64";
            min-p = "0.0";
            batch-size = "2048";
            ubatch-size = "2048";
            repeat-penalty = "1.0";
            presence-penalty = "0.0";
            cache-type-k = "q8_0";
            cache-type-v = "q8_0";
            flash-attn = "on";
            jinja = "on";
            tools = "on";
          };
        };
      };
    };
}
