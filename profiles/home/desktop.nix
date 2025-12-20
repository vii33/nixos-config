{ config, pkgs, pkgs-unstable, ... }:

{
  imports = [
    ../../modules/home/kde.nix   # has to move to host
    ../../modules/home/onedriver.nix #same

    # Niri-related home modules (moved from profiles/home/niri.nix)
    ../../modules/system/niri.nix
    ../../modules/home/niri/niri.nix
    ../../modules/home/niri/waybar.nix
    ../../modules/home/niri/fuzzel.nix
    ../../modules/home/niri/mako.nix
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
