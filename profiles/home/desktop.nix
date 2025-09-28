{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    brave
    obsidian
    bitwarden-desktop
    signal-desktop-bin
    thunderbird
    vlc
  ];
}
