{ config, pkgs, ... }:

{
  # Enable fish shell system-wide
  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    nfs-utils     # NFS share
    vim
    mtr           # My traceroute
    htop
    fzf
    zoxide
    eza
    ripgrep
    fd
    bat
  ];
}
