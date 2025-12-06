{ config, pkgs, ... }:

{
  imports = [
    ../../modules/home/fish-shell.nix
    ../../modules/home/nixvim/lazyvim.nix
  ];

  home.packages = with pkgs; [
    opencode
    github-copilot-cli
  ];
  

}
