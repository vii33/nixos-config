# modules/system/niri.nix
# System-level configuration for niri Wayland compositor
{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.niri.nixosModules.niri
  ];

  # Enable niri compositor
  programs.niri.enable = true;

  # XWayland support
  programs.xwayland-satellite.enable = true;

  # Ensure required services are available
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd niri-session";
        user = "greeter";
      };
    };
  };

  # Ensure essential Wayland environment
  environment.systemPackages = with pkgs; [
    wl-clipboard
  ];
}
