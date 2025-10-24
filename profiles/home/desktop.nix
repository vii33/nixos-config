{ config, pkgs, pkgs-unstable, ... }:

{
  home.packages = with pkgs; [
    brave
    obsidian
    bitwarden-desktop
    signal-desktop-bin
    thunderbird
    vlc
    pkgs-unstable.onedriver
  ];
}
