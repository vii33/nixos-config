{ config, pkgs, ... }:

{
  imports = [
    ../../modules/home/alacritty.nix
  ];

  home.packages = with pkgs; [
    vscode-fhs
  ];
}
