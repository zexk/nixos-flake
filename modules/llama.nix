_: {
  flake.nixosModules.llama =
    { pkgs, ... }:
    {
      services.llama-cpp = {
        enable = true;
        package = pkgs.llama-cpp.override { cudaSupport = true; };
        modelsPreset = {
          "qwen3-14b" = {
            hf-repo = "bartowski/Qwen_Qwen3-14B-GGUF:Q2_K_L";
            alias = "qwen3-14b";
						n-predict = "-1";
            c = "16384";
            ngl = "99";
            temp = "0.7";
            top-p = "0.8";
            top-k = "20";
            min-p = "0.0";
            jinja = "on";
            flash-attn = "on";
            cache-type-k = "q8_0";
            cache-type-v = "q8_0";
            threads = "6";
          };
        };
      };
    };
}
