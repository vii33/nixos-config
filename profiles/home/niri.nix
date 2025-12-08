# profiles/home/niri.nix
# Home Manager profile for niri Wayland compositor
{ config, pkgs, ... }:

{
  imports = [
    ../../modules/home/niri.nix
    ../../modules/home/waybar.nix
    ../../modules/home/fuzzel.nix
    ../../modules/home/mako.nix
  ];
}
