# /etc/nixos/home/vii/home.nix
{ config, pkgs, ... }:

# home-manager.users.vii = {...}:
{
  # Import user specific packages
  imports = [
    # ./packages.nix
  ];

  # Set minimal infos for home manager: user, home directory and state version
  home.username = "vii";
  home.homeDirectory = "/home/vii";
  
  # Configure user-level programs
  programs.fish.enable = true;
  programs.direnv.enable = true;

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # Ensures configuration doesn't break on updates. Keep version static after first config.
  # You can update Home Manager without changing this value. See the Home Manager release
  # notes for a list of state version changes in each release.
  home.stateVersion = "25.05";   
}