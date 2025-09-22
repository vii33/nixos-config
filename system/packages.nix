# /etc/nixos/system/packages.nix
{ pkgs, ... }:

{
  # System-wide packages 
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
    mtr           # My traceroute
    htop          # Interactive process viewer
    nbfc-linux    # Notebook Fan Control
  ];
}
