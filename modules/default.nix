# ./modules/default.nix
{ config, pkgs, ... }:

{
# PROGRAMS 
programs.firefox.enable = true;

# System-wide packages 
environment.systemPackages = with pkgs; [
  vim 
  #wget
  mtr           # My traceroute
  htop          
];

fonts.packages = with pkgs; [
  nerd-fonts.meslo-lg          # Used by Fish Shell / Alacritty
  nerd-fonts.jetbrains-mono
];

# Allow unfree packages
nixpkgs.config.allowUnfree = true;

}