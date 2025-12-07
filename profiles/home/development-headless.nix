{ config, pkgs, pkgs-unstable, ... }:

{
  imports = [
    ../../modules/home/fish-shell.nix
    ../../modules/home/nixvim/lazyvim.nix
  ];

  home.packages = with pkgs; [
    pkgs-unstable.opencode
    pkgs-unstable.github-copilot-cli
  ];
  

}
