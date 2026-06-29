{ pkgs-unstable, ... }:

{
  services.ollama = {
    enable = true;
    package = pkgs-unstable.ollama;

    environmentVariables = {
      # Real context allocated by the Ollama server.
      OLLAMA_CONTEXT_LENGTH = "16384";

      # Keep only one large model loaded on a 16 GB machine.
      OLLAMA_MAX_LOADED_MODELS = "1";

      # Avoid concurrent requests multiplying memory usage.
      OLLAMA_NUM_PARALLEL = "1";

      # Unload models after five minutes of inactivity.
      OLLAMA_KEEP_ALIVE = "5m";
    };
  };
}
