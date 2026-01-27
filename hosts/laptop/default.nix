# ./hosts/laptop/default.nix
{ config, pkgs, inputs, pkgs-unstable, ... }:

{
  imports =
    [ 
      # Only System level modules here! Home manager further down. Home Manager modules must be imported at user level, not system 
      inputs.home-manager.nixosModules.home-manager
      ./configuration.nix
      ./hardware-configuration.nix

      # Common configuration
      ../../modules/system/common_all.nix
      ../../modules/system/common_linux.nix

      # Direct module imports
      ../../modules/system/niri.nix
      ./swap.nix
      ./nbfc.nix
    ];

  # Development system packages
  environment.systemPackages = with pkgs; [
    python3
    uv
    docker
    docker-compose
  ];
  environment.localBinInPath = true;
  virtualisation.docker.enable = true;

  # Fonts
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
      ../../modules/home/kitty.nix
      ../../modules/home/fish-shell.nix
      ../../modules/home/nixvim/nixvim.nix
      ../../modules/home/nixvim/lazyvim.nix
      ../../modules/home/kde.nix

      ../../modules/home/onedriver.nix

      ../../modules/home/niri/niri.nix
      ../../modules/home/niri/waybar.nix
      ../../modules/home/niri/fuzzel.nix
      ../../modules/home/niri/mako.nix
      ../../modules/home/niri/power-menu.nix
    ];
  home-manager.users.vii = {
    imports = [ ../../home/vii/home-linux.nix ];
    
    # Host-specific packages for laptop
    home.packages = with pkgs; [
      brave
      obsidian
      bitwarden-desktop
      signal-desktop-bin
      thunderbird
      vlc
      pkgs-unstable.vscode
      pkgs-unstable.opencode
      pkgs-unstable.github-copilot-cli
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
