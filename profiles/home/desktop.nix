{ config, pkgs, pkgs-unstable, ... }:

{
  imports = [
    ../../modules/home/kde.nix   # has to move to host
    ../../modules/home/onedriver.nix #same
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
