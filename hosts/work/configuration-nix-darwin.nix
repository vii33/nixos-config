# ./hosts/work/configuration-nix-darwin.nix
# Basic nix-darwin configuration for macOS work host
{ config, pkgs, ... }:

let
  localConfig = import ../../local-config.nix;
in
{
  # Set the system architecture for this macOS host
  nixpkgs.hostPlatform = "aarch64-darwin";  # Apple Silicon (change to "x86_64-darwin" for Intel)

  # Set primary user for nix-darwin
  system.primaryUser = localConfig.macosUsername;

  # Configure Nix settings
  nix.settings = {
    http-connections = 50;
    connect-timeout = 30;
    download-attempts = 5;
  };

  # Automatische Bereinigung des Nix-Speichers (Gegen Datenmüll)
  nix.gc = {
    automatic = true;
    interval = { Weekday = 1; Hour = 8; Minute = 0; }; # Jeden Montag um 08:00 Uhr
    options = "--delete-older-than 40d";
  };


  # Set proxy environment variables for Nix daemon
  launchd.daemons.nix-daemon.environment = {
    HTTP_PROXY = "http://localhost:3128";
    HTTPS_PROXY = "http://localhost:3128";
  };
  
  system.defaults = {
    # Dock
    dock = {
      autohide = false;
      show-recents = false;
      tilesize = 48;
      orientation = "bottom";
    };

    # Finder-Optionen
    finder = {
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "clmv"; # Spaltenansicht
      ShowPathbar = true;
      _FXShowPosixPathInTitle = true;
    };

    # Globale UI/Input Einstellungen
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      #AppleInterfaceStyle = "Dark"; # Dark Mode
      KeyRepeat = 4;                # delay per repeat
      InitialKeyRepeat = 30;        # delay before repeat
    };
  };

  # Caps Lock auf Escape umlegen
  system.keyboard = {
    enableKeyMapping = true;
    remapsCapsLockToEscape = true;
  };

  # Sudo mit Touch ID erlauben
  security.pam.enableSudoTouchIdAuth = true;

  # Nerd Fonts installieren (für ein schöneres Terminal)
  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.fira-code
  ];

  # Programs to enable system-wide
  #programs.zsh.enable = true;  # Default shell on macOS
  #programs.bash.enable = true;
}