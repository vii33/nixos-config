# modules/home/niri/mako.nix
# Mako notification daemon for Wayland
{ config, pkgs, ... }:

{
  services.mako = {
    enable = true;
    
    # Visual settings
    font = "JetBrainsMono Nerd Font 11";
    backgroundColor = "#282a36";
    textColor = "#f8f8f2";
    borderColor = "#bd93f9";
    progressColor = "over #44475a";
    
    # Layout
    width = 400;
    height = 150;
    margin = "10";
    padding = "15";
    borderSize = 2;
    borderRadius = 8;
    
    # Behavior
    maxVisible = 5;
    defaultTimeout = 5000;  # 5 seconds
    ignoreTimeout = false;
    
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
