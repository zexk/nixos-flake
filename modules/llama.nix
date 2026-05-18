{ inputs, ... }:
{
  flake.nixosModules.llama =
    { pkgs, lib, ... }:
    let
      llama-cpp-vulkan =
        inputs.llama.packages.${pkgs.stdenv.hostPlatform.system}.vulkan.overrideAttrs
          (old: {
            cmakeFlags = (builtins.filter (f: !(lib.hasPrefix "-DLLAMA_BUILD_WEBUI" f)) old.cmakeFlags) ++ [
              "-DLLAMA_BUILD_UI=OFF"
              "-DLLAMA_BUILD_WEBUI=OFF"
            ];
          });
    in
    {
      services.llama-cpp = {
        enable = true;
        package = llama-cpp-vulkan;
        modelsPreset = {
          "qwen3-6-27b" = {
            hf-repo = "froggeric/Qwen3.6-27B-MTP-GGUF:IQ4_XS";
            alias = "qwen3-6-27b";
            n-predict = "-1";
            c = "16384";
            ngl = "999";
            temp = "0.6";
            top-p = "0.95";
            top-k = "20";
            min-p = "0.0";
            batch-size = "2048";
            ubatch-size = "512";
            repeat-penalty = "1.0";
            presence-penalty = "0.0";
            cache-type-k = "q8_0";
            cache-type-v = "q8_0";
            flash-attn = "on";
            jinja = "on";
            spec-type = "draft-mtp";
            spec-draft-n-max = "3";
          };
        };
      };
    };
}
