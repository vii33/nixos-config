# modules/home/niri/noctalia.nix
# Noctalia Shell configuration for the Niri desktop
{ config, ... }:

let
  dotfilesDir = "${config.home.homeDirectory}/nixos-config/dotfiles";
in

{
  programs.noctalia-shell.enable = true;

  xdg.configFile."noctalia".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/noctalia";
}
