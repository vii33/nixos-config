# /etc/nixos/home/vii/home-darwin.nix
# Home Manager configuration for macOS (nix-darwin)
# TODO Merge this with the home-linux.nix

{ config, pkgs, lib, localConfig, ... }:

{
  # Import user specific packages
  imports = [
    #./git.nix
  ];

  # Set user and home directory for macOS (from local-config.nix)
  home.username = localConfig.macosUsername;
  home.homeDirectory = lib.mkForce "/Users/${localConfig.macosUsername}";

  # Add home-manager CLI to PATH
  home.packages = with pkgs; [
    home-manager
  ];

  # Configure user-level programs
  programs.fish.enable = true;

  # Ensures configuration doesn't break on updates. Keep version static after first config.
  # You can update Home Manager without changing this value. See the Home Manager release
  # notes for a list of state version changes in each release.
  home.stateVersion = "25.05";   
}
