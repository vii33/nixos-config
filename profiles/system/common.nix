{ config, pkgs, ... }:

{
  # Basic Nix settings
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Build optimizations
  nix.settings = {
    download-buffer-size = 128 * 1024 * 1024; # 128 MiB
    max-jobs = "auto";                          # Use all CPU cores for parallel builds
    cores = 2;                                # Limit each build to 2 cores
    auto-optimise-store = true;               # Save disk space automatically
  };

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
    zoxide        # smart cd (integration handled in home module)
    eza
    ripgrep
    fd
    bat
    git
  ];

}
