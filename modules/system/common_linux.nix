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
  };
  
  programs.command-not-found.enable = true;
  
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/vii/nixos-config";
  };

  # System locale, timezone, console keymap and user account
  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  console.keyMap = "de";

  # Define user accounts. Keep as a system-level declaration.
  users.users.vii = {
    isNormalUser = true;
    description = "vii";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.fish;
  };
  
  # Linux-only packages
  environment.systemPackages = with pkgs; [
    nfs-utils     # NFS share
    efibootmgr    # EFI boot manager for troubleshooting boot issues
  ];
}
