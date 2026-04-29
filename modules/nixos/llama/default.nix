{ inputs, pkgs, ... }:
{
  services.llama-cpp = {
    enable = true;
    package = pkgs.llama-cpp.override { cudaSupport = true; };
    openFirewall = true;
    modelsPreset = {
      "gemma-4-e4b" = {
        hf-repo = "HauhauCS/Gemma-4-E4B-Uncensored-HauhauCS-Aggressive:Q4_K_M";
        temp = "1.0";
        top-p = "0.95";
        min-p = "0.01";
        top-k = "64";
        c = "8192";
        jinja = "on";
      };
    };
  };
}
