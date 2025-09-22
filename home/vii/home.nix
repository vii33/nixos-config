# /etc/nixos/home/myuser/home.nix
{ config, pkgs, ... }:

{
  # Import this user's packages
  imports = [ ./packages.nix ];

  # Set minimal infos for home manager: user, home directory and state version
  home.username = "vii";
  home.homeDirectory = "/home/vii";
  
  # Ensures configuration doesn't break on updates. Keep version static after first config.
  # You can update Home Manager without changing this value. See the Home Manager release
  # notes for a list of state version changes in each release.
  home.stateVersion = "25.05";   

  # Configure user-level programs
  # programs.starship.enable = true;
  # programs.direnv.enable = true;

  # Let Home Manager manage itself
  programs.home-manager.enable = true;
}