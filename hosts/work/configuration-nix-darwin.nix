# ./hosts/work/configuration-nix-darwin.nix
# Basic nix-darwin configuration for macOS work host
# Settings: https://nix-darwin.github.io/nix-darwin/manual/index.html
{ config, pkgs, ... }:

let
  localConfig = import ../../local-config.nix;
in
{
  # Set the system architecture for this macOS host
  nixpkgs.hostPlatform = "aarch64-darwin";  # Apple Silicon (change to "x86_64-darwin" for Intel)

  # Set primary user for nix-darwin
  system.primaryUser = localConfig.macosUsername;

  # Startup
  system.startup.chime = false;  # Disable startup chime for quieter boot

  # Configure Nix settings
  nix.settings = {
    http-connections = 50;
    connect-timeout = 30;
    download-attempts = 5;
  };

  # Nix optimization
  nix.optimise = {
    automatic = true;  # Optimize nix store weekly to save disk space
    interval = { Weekday = 1; Hour = 8; Minute = 0; }; # Every Monday at 08:00
  };


  # Garbage collection settings
  nix.gc = {
    automatic = true;
    interval = { Weekday = 1; Hour = 8; Minute = 0; }; # Every Monday at 08:00
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
      tilesize = 36;
      orientation = "bottom";
      # Hot Corners
      wvous-tr-corner = 12;
      wvous-br-corner = 2;
    };

    # Screenshots
    screencapture = {
      target = "preview";  # Save screenshots to clipboard,  "file", "preview", "mail", "messages")
      location = "~/Documents/Screenshots";  # Organize screenshots in dedicated folder
    };

    # Keyboard & Input
    hitoolbox = {
      AppleFnUsageType = "Show Emoji & Symbols"; 
    };

    # Control Center
    controlcenter = {
      NowPlaying = false;  # Show Now Playing control in menu bar
    };

    # Mouse
    ".GlobalPreferences" = {
      "com.apple.mouse.scaling" = 2.0;  # Standard mouse speed (range typically 0-3)
    };

    # Finder options
    finder = {
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "clmv"; # Spaltenansicht
      ShowPathbar = true;
      _FXShowPosixPathInTitle = true;
    };

    # Global UI/Input
    NSGlobalDomain = {
      AppleShowAllExtensions = true;

      # Keyboard
      KeyRepeat = 4;                # delay per repeat
      InitialKeyRepeat = 30;        # delay before repeat

      # Trackpad
      "com.apple.trackpad.scaling" = 0.875;  # Standard trackpad speed (range typically 0-3)
      
      # Panels
      PMPrintingExpandedStateForPrint = true;  # Use expanded print panel by default
      PMPrintingExpandedStateForPrint2 = true;  # Use expanded print panel by default (alternate key)
      NSWindowResizeTime = 0.1;  # Faster window resize animation (default typically 0.2)
      NSNavPanelExpandedStateForSaveMode = true;  # Use expanded save panel by default
      NSNavPanelExpandedStateForSaveMode2 = true;  # Use expanded save panel by default (alternate key)
      
      #NSDisableAutomaticTermination = false;  # Allow automatic termination of inactive apps
      
      # Spelling
      NSAutomaticSpellingCorrectionEnabled = false;  # Disable autocorrect for development work
      NSAutomaticQuoteSubstitutionEnabled = true;  # Disable smart quotes for code editing
      NSAutomaticPeriodSubstitutionEnabled = false;  # Disable period substitution
      NSAutomaticCapitalizationEnabled = false;  # Disable auto-capitalization for terminals/code
      
      # AppleScrollerPagingBehavior = null;  # Keep default scrolling behavior
    };
  };

  # Point Caps Lock to Escape
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };

  # Trackpad
  system.defaults.trackpad = {
    #TrackpadThreeFingerVertSwipeGesture = 2;  # Enable three-finger vertical swipe for App Exposé
    TrackpadThreeFingerDrag = true;  # Enable three-finger drag for window management 
  };

  # Sudo with Touch ID
  security.pam.services.sudo_local.enable = true;  # Keep enabled for sudo PAM services
  security.pam.services.sudo_local.touchIdAuth = true;

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    fira-code
    fira-code-symbols
    noto-fonts
    noto-fonts-color-emoji
  ];

  # Programs
  programs.zsh = {
    # interactiveShellInit = "";  # Add custom zsh init if needed
    enableSyntaxHighlighting = true;  # Enable syntax highlighting for better visibility
    enableFzfHistory = true;  # Enable fuzzy history search (Ctrl-R)
    enableFzfCompletion = true;  # Enable fuzzy completion
    enableCompletion = true;  # Keep completion enabled
    #enableAutosuggestions = true;  # Enable autosuggestions for productivity
  };

  programs.fish = {
    enable = true;  # Only enable if you use fish shell
    # promptInit = "";  # Add custom fish init if using fish
  };

  # Power
  power.sleep.allowSleepByPowerButton = null;  

  # Activation scripts to fix Spotlight indexing for Nix apps (otherwise they don't show up in Spotlight)
  system.activationScripts.applications.text = pkgs.lib.mkForce ''
    echo "Indexing Nix applications for Launchpad/Spotlight..." >&2

    # Activation scripts run as root, so writing into ~/Applications would land in /var/root.
    # Use the system Applications folder instead.
    target="/Applications/Nix Apps"
    user_home="/Users/${localConfig.macosUsername}"
    hm_apps="$user_home/Applications/Home Manager Apps"

    rm -rf "$target"
    mkdir -p "$target"

    if [ -d "${config.system.build.applications}/Applications" ]; then
      find "${config.system.build.applications}/Applications" -maxdepth 1 -type l -print |
      while IFS= read -r link; do
        src=$(readlink "$link")
        app_name=$(basename "$src")
        echo "Aliasing $app_name" >&2
        ${pkgs.mkalias}/bin/mkalias "$src" "$target/$app_name"
      done
    fi

    # Rebuild Launch Services entries so Launchpad/Spotlight pick up the apps.
    /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister \
      -f "$target"/*.app 2>/dev/null || true
    /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister \
      -f "$hm_apps"/*.app 2>/dev/null || true
    /usr/bin/killall Dock 2>/dev/null || true
  '';
 
}