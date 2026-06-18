{ config, pkgs, ... }:

{
  # Basic Nix settings
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Enable fish shell system-wide.
  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    mtr # My traceroute
    htop
    fzf
    zoxide # smart cd (integration handled in home module)
    eza
    ripgrep
    fd
    bat
    git
    gh
    sops
    age
  ];
}
