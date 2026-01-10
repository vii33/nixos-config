# modules/home/niri/mako.nix
# Mako notification daemon for Wayland
{ config, pkgs, ... }:

{
  services.mako.enable = true;

  services.mako.settings = {
    # Visual settings
    font = "JetBrainsMono Nerd Font 11";
    background-color = "#282a36";
    text-color = "#f8f8f2";
    border-color = "#bd93f9";
    progress-color = "over #44475a";
    
    # Layout
    width = 400;
    height = 150;
    margin = "10";
    padding = "15";
    borderSize = 2;
    borderRadius = 8;
    
    # Behavior
    max-visible = 5;
    default-timeout = 5000;  # 5 seconds
    ignore-timeout = false;
    
    # Position
    anchor = "top-right";
    
    # Icons
    iconPath = "${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark";
    maxIconSize = 64;
  };

  # Install icon theme for notifications
  home.packages = with pkgs; [
    papirus-icon-theme
  ];
}
