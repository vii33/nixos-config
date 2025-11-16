{ config, pkgs, pkgs-unstable, ... }:

{
  imports = [
    ../../modules/home/kitty.nix
  ];

  home.packages = with pkgs; [
    pkgs-unstable.vscode
  ];
}
