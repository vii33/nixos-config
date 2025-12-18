# /etc/nixos/home/vii/home-darwin.nix
# Home Manager configuration for macOS (nix-darwin)
{ config, pkgs, ... }:

{
  # Import user specific packages
  imports = [
    #./git.nix
  ];

  # On macOS, home.username and home.homeDirectory are managed by the system
  # No need to set them explicitly

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
