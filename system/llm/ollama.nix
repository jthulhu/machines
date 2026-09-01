{ lib, pkgs, config, ... }:
let
  inherit (lib.strings) hasPrefix;
  inherit (config.my) gpu;
  gpu-can-handle-llm = hasPrefix "nvidia" gpu;
in {
  services.ollama = {
    enable = true;
    package = if gpu-can-handle-llm then pkgs.ollama-cuda else pkgs.ollama-cpu;

    syncModels = true;
    loadModels = [
      # Models that can run anywhere
    ] ++ lib.optionals (!gpu-can-handle-llm) [
      # Smart web search, small enough to run on CPU
      "llama3.1:8b" 
    ] ++ lib.optionals gpu-can-handle-llm [
      # Heavy models
      "richardyoung/olmocr2:7b-q8"
    ];

    environmentVariables = {
      OLLAMA_HOST = "127.0.0.1:11434";
    };
  };
}
