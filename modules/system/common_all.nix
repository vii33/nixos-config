{ config, pkgs, ... }:

{
  # Basic Nix settings
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable fish shell system-wide //TODO can this be moved somewhere else?
  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    mtr           # My traceroute
    htop
    fzf
    zoxide        # smart cd (integration handled in home module)
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
