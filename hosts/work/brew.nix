{ config, pkgs, ... }:

{
 # Homebrew Konfiguration (Für GUI-Apps, App Store und macOS-spezifische Tools)
  homebrew = {
    enable = true;
    
    onActivation = {
      cleanup = "zap"; # Löscht Brew-Pakete, die nicht mehr in dieser Liste stehen
      autoUpdate = true;
      upgrade = true;
    };

    # Klassische Terminal-Tools via Brew (falls in nixpkgs nicht verfügbar)
    brews = [
      #"mas" # CLI Tool für den Mac App Store (wichtig für masApps)
    ];

    # macOS App Bundles (.app Dateien)
    casks = [
      #"visual-studio-code"
      #"spotify"
      "rectangle" # Window Management
    ];
  };
}