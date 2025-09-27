{ config, pkgs, ... }:

{
  imports = [
    ../../modules/home/fish-shell.nix
    ../../modules/home/alacritty.nix
  ];

  home.packages = with pkgs; [
    vscode-fhs
    git
    #ishPlugins.tide   # Needs to be explicitly installed to be available in fish
  ];
}
