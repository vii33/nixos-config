# /etc/nixos/home/vii/home-darwin.nix
# Home Manager configuration for macOS (nix-darwin)
{ config, pkgs, lib, localConfig, ... }:

{
  # Import user specific packages
  imports = [
    #./git.nix
  ];

  # Set user and home directory for macOS (from local-config.nix)
  home.username = localConfig.macosUsername;
  home.homeDirectory = lib.mkForce "/Users/${localConfig.macosUsername}";

  # Configure user-level programs
  programs.fish.enable = true;
  ########programs.direnv.enable = true;

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # Ensures configuration doesn't break on updates. Keep version static after first config.
  # You can update Home Manager without changing this value. See the Home Manager release
  # notes for a list of state version changes in each release.
  home.stateVersion = "25.05";   
}
