# ./modules/default.nix
{ config, pkgs, ... }:

{
# PROGRAMS ###################################################
programs.firefox.enable = true;
programs.fish.enable = true;


# Allow unfree packages
nixpkgs.config.allowUnfree = true;

fonts.packages = with pkgs; [
# Fonts go here, search on nixos packages website and check
# that NIX EXPRESSION starts with pkgs/data/fonts

# font-awesome_4
];

}