# ./hosts/laptop/default.nix
{ config, pkgs, inputs, ... }:

{
  imports =
    [ 
      # Only System level modules here! Home manager further down. Home Manager modules must be imported at user level, not system 
      inputs.home-manager.nixosModules.home-manager
      ./configuration.nix
      ./hardware-configuration.nix

      # Direct module imports (previously from profiles)
      ../../modules/system/niri.nix
      
      ./swap.nix
      ./nbfc.nix
    ];

  # === From profiles/system/common_all.nix ===
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
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
    yazi
    # From profiles/system/common_linux.nix (Linux-only packages)
    nfs-utils     # NFS share
    efibootmgr    # EFI boot manager for troubleshooting boot issues
    # From profiles/system/development-headless.nix
    python3
    uv
    docker
    docker-compose
  ];

  # === From profiles/system/common_linux.nix ===
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
  
  # From profiles/system/development-headless.nix
  environment.localBinInPath = true;
  virtualisation.docker.enable = true;

  # === From profiles/system/desktop.nix ===
  fonts.packages = with pkgs; [
    nerd-fonts.meslo-lg          # Used by Fish Shell / Alacritty
    nerd-fonts.jetbrains-mono
  ];

  # Home Manager wiring for this host
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";   # backup existing dotfiles before overwriting
  home-manager.extraSpecialArgs = { inherit (config._module.specialArgs) pkgs-unstable; };
  home-manager.sharedModules =  # Home Manager modules shared between all users
    [
      inputs.nixvim.homeManagerModules.nixvim
      # From profiles/home/desktop.nix
      ../../modules/home/kde.nix
      ../../modules/home/onedriver.nix
      ../../modules/home/niri/niri.nix
      ../../modules/home/niri/waybar.nix
      ../../modules/home/niri/fuzzel.nix
      ../../modules/home/niri/mako.nix
      # From profiles/home/development-desktop.nix
      ../../modules/home/kitty.nix
      # From profiles/home/development-headless.nix
      ../../modules/home/fish-shell.nix
      ../../modules/home/nixvim/lazyvim.nix
    ];
  home-manager.users.vii.imports = [ ./home.nix ../../home/vii/home-linux.nix ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
