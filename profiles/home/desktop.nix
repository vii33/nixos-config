{ config, pkgs, pkgs-unstable, ... }:

{
  imports = [
    ../../modules/home/kde.nix
  ];

  home.packages = with pkgs; [
    brave
    obsidian
    bitwarden-desktop
    signal-desktop-bin
    thunderbird
    vlc
    pkgs-unstable.onedriver     # https://github.com/jstaf/onedriver
  ];
}
