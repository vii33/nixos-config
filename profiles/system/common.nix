{ config, pkgs, ... }:

{
  # Enable fish shell system-wide
  programs.fish.enable = true;

  # Enable command-not-found to suggest packages for missing commands
  programs.command-not-found.enable = true;

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
    git
    nvim
  ];
}
