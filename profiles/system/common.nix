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
    
    # Binary caches
    substituters = [
      "https://cache.nixos.org"
      "https://niri.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
    ];
  };

  # Enable fish shell system-wide //TODO can this be moved somewhere else?
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
    efibootmgr    # EFI boot manager for troubleshooting boot issues
    yazi
  ];

  # Nix Helper CLI, to simplify nixos-rebuild and nix-collect-garbage usage
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/vii/nixos-config"; # sets NH_OS_FLAKE variable for you
  };

}
