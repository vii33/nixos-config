{ config, pkgs, ... }:

{
  imports = [
    ../../modules/home/fish-shell.nix
    #../../modules/home/neovim.nix
    #../../modules/home/nixvim/default.nix
    ../../modules/home/nixvim/lazyvim.nix
    #../../modules/home/nixvim/relief.nix
  ];

  home.packages = with pkgs; [
  ];
  

}
