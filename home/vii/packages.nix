# /etc/nixos/home/vii/packages.nix
{ pkgs, ... }:

{
  # User-specific packages
  home.packages = [
    brave
    obsidian
    onedrive
    #spotify
    #thunderbird
    #docker
    vscode.fhs
    git
    bitwarden-desktop
    #vlc
    nfs-utils     # NFS share
   ];
}