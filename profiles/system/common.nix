{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    nfs-utils     # NFS share
    vim
    mtr           # My traceroute
    htop
    fzf
    zoxide
    eza
  ];
}
