# profiles/system/niri.nix
# System-level profile for niri Wayland compositor
{ config, pkgs, ... }:

{
  imports = [
    ../../modules/system/niri.nix
  ];
}
