# ./modules/default.nix
{ config, pkgs, ... }:

{
# PROGRAMS 
programs.firefox.enable = true;


# Allow unfree packages
nixpkgs.config.allowUnfree = true;

fonts.packages = with pkgs; [
  nerd-fonts.meslo-lg  # Used by Fish Shell
];



}