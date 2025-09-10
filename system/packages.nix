# /etc/nixos/system/packages.nix
{ pkgs, ... }:

{
  # List system-wide packages here
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #wget
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
