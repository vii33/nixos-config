{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    python3
    uv
    docker  # Docker is managed via brew on macOS
    docker-compose
  ]
  
  # NixOS/Linux-only options (these option paths don't exist on nix-darwin)
  environment.localBinInPath = true;
  virtualisation.docker.enable = true;
}
