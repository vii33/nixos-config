{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    brave
    obsidian
    bitwarden-desktop
  ];
}
