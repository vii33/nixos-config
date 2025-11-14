# ./modules/home-manager/mouse.nix
{ config, pkgs, ... }:

{
  # Configure mouse pointer speed for high DPI mice (e.g., Logitech Pro)
  # These settings work with libinput on Wayland (KDE Plasma)
  
  home.packages = with pkgs; [
    libinput  # For debugging: libinput list-devices, libinput debug-events
  ];

  # Create libinput configuration file to target only external mice (not touchpad)
  xdg.configFile."libinput/local-overrides.quirks" = {
    text = ''
      [Logitech G Pro Mouse]
      MatchName=*Logitech G Pro*     # glob pattern, * is wildcard
      MatchIsPointer=true
      MatchIsTouchpad=false
      AttrPointerAcceleration=-1.0   # -1.0 (slow) to 1.0 (fast), 0 is default
      #AttrAccelProfileFlat=1
    '';
  };
}
