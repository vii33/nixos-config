{ config, pkgs, ... }:

{
  imports = [
    ../../modules/home/fish-shell.nix
  ];

  home.packages = with pkgs; [
    docker
    docker-compose
    python3Minimal
    uv
  ];

  # Handy if you use uv’s default install locations (~/.local/bin)
  environment.localBinInPath = true;
}
