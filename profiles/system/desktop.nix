{ config, pkgs, ... }:

{
  fonts.packages = with pkgs; [
    nerd-fonts.meslo-lg          # Used by Fish Shell / Alacritty
    nerd-fonts.jetbrains-mono
  ];
}
