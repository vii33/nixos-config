{ config, pkgs, ... }:

{
  imports = [
    ../../modules/home/fish-shell.nix
    ../../modules/home/nixvim/lazyvim.nix
  ];

  home.packages = with pkgs; [
    lazygit
    thefuck
  ];
  

}
