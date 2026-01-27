# modules/home/warpd.nix
# warpd - modal keyboard-driven interface for mouse pointer control
{ config, pkgs, lib, ... }:

{
  # warpd is installed via environment.systemPackages in host configuration
  
  home.file.".config/warpd/config".text = ''
    # warpd configuration
    # See: https://github.com/rvaiya/warpd
    
    # Key notation:
    # M = Meta/Alt (Option key on macOS, Alt on Linux)
    # C = Control
    # S = Shift
    # A = Alt (rarely used, usually M is preferred)
    
    # Default activation keys:
    # M-x = Grid mode (Alt+x / Option+x)
    # M-c = Hint mode (Alt+c / Option+c)
    # M-g = Normal mode (Alt+g / Option+g)
    
    # Uncomment and modify as needed:
    # activation_key: M-x
    
    # Grid size and appearance
    # grid_size: 2
    # grid_color: #ff0000
    
    # Add your custom warpd configuration here
  '';
}
