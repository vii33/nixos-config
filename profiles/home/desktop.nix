{ config, pkgs, pkgs-unstable, ... }:

{
  imports = [
    ../../modules/home/kde.nix
    ../../modules/home/onedriver.nix
  ];

  home.packages = with pkgs; [
    brave
    obsidian
    bitwarden-desktop
    signal-desktop-bin
    thunderbird
    vlc
  ];
}
