{ config, pkgs, ... }:

{
  imports = [
    ../../modules/home/fish-shell.nix
    #../../modules/home/neovim.nix
    ../../modules/home/nixvim.nix
  ];

  home.packages = with pkgs; [
  ];


}
