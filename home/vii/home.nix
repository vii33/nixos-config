# /etc/nixos/home/myuser/home.nix
{ config, pkgs, ... }:

{
  # Import this user's packages
  imports = [ ./packages.nix ];

  # Set home directory and state version
  home.username = "vii";
  home.homeDirectory = "/home/vii";
  home.stateVersion = "25.05";

  # Configure user-level programs
  # programs.starship.enable = true;
  # programs.direnv.enable = true;

  # Let Home Manager manage itself
  programs.home-manager.enable = true;
}