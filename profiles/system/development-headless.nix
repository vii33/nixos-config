{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    docker
    docker-compose
    python3
    uv
  ];

  # Needed if uv / pip is needed as the put packages there (/.local/bin)
  environment.localBinInPath = true;

  # Enable and start Docker service
  virtualisation.docker.enable = true;
}
