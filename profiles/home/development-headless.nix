{ config, pkgs, ... }:

{
  imports = [
    ../../modules/home/fish-shell.nix
    ../../modules/home/neovim.nix
  ];

  home.packages = with pkgs; [
    docker
    docker-compose
    python3Minimal
    uv
  ];


}
