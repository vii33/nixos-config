# modules/system/niri.nix
# System-level configuration for niri Wayland compositor
# This makes niri available as a session option alongside KDE
{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.niri.nixosModules.niri
  ];

  # Enable niri compositor (makes it available as a session)
  programs.niri.enable = true;

  # XWayland support
  programs.xwayland-satellite.enable = true;

  # Ensure essential Wayland environment
  environment.systemPackages = with pkgs; [
    wl-clipboard
  ];
}
