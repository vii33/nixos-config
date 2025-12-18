{ config, pkgs, ... }:

{
  # NixOS-specific options (not available on nix-darwin)
  # Import this module only in NixOS hosts, not in macOS/Darwin hosts
  
  # Build optimizations
  nix.settings = {
    download-buffer-size = 128 * 1024 * 1024; # 128 MiB
    max-jobs = "auto";                          # Use all CPU cores for parallel builds
    cores = 2;                                # Limit each build to 2 cores
    auto-optimise-store = true;               # Save disk space automatically
    
    # Needed for the cache to be trusted
    trusted-users = [ "root" "@wheel" ]; # root user and all users in wheel group
    
    # Add binary caches - only needed when building directly from the flake (not from pkgs.niri)
    #substituters = [
    #  "https://cache.nixos.org"
    #  "https://niri.cachix.org"
    #];
    #trusted-public-keys = [
    #  "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    #  "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
    #];
  };
  
  programs.command-not-found.enable = true;
  
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/vii/nixos-config";
  };
  
  # Linux-only packages
  environment.systemPackages = with pkgs; [
    nfs-utils     # NFS share
    efibootmgr    # EFI boot manager for troubleshooting boot issues
  ];
}
