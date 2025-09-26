{ config, pkgs, ... }:

{
  # environment.systemPackages = with pkgs; [
  #   # Add packages here
  # ];

  programs.firefox.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.meslo-lg          # Used by Fish Shell / Alacritty
    nerd-fonts.jetbrains-mono
  ];
}
