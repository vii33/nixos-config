# /etc/nixos/home/vii/packages.nix
{ pkgs, ... }:

{
  # User-specific packages
  home.packages = with pkgs; [
    brave
    obsidian
    #onedrive   # creates high cpu load
    #spotify
    #thunderbird
    #docker
    vscode-fhs
    git
    bitwarden-desktop
    #vlc
    nfs-utils     # NFS share
   ];
}