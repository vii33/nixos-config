{ config, pkgs, pkgs-unstable, ... }:

{
  imports = [
    ../../modules/home/alacritty.nix
  ];

  home.packages = with pkgs; [
    pkgs-unstable.vscode
  ];
}
