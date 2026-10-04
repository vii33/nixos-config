# modules/system/niri.nix
# System-level configuration for niri Wayland compositor
# This makes niri available as a session option alongside KDE
{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    inputs.niri.nixosModules.niri
  ];

  # Disable niri-flake's automatic cache configuration (we manage it in common.nix)
  niri-flake.cache.enable = false;

  # Use upstream's signed Noctalia binaries for subsequent builds after activation.
  nix.settings = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  # Enable niri compositor (makes it available as a session)
  programs.niri = {
    enable = true;
    # Use the niri package from nixpkgs (available in cache.nixos.org)
    # instead of building from niri-flake
    package = pkgs.niri;
  };

  # XWayland support
  #  programs.xwayland-satellite.enable = true;  # not existing setting - remove?

  # XDG Desktop Portal for file pickers, screen sharing, etc.
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
    config.common.default = "*";
  };

  # Ensure essential Wayland environment
  environment.systemPackages = with pkgs; [
    wl-clipboard
    nautilus # Primary GUI file manager; also backs GNOME portal file picker
  ];
}
