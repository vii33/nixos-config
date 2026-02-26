# ./hosts/work/configuration-nix-darwin.nix
# Basic nix-darwin configuration for macOS work host
# Settings: https://nix-darwin.github.io/nix-darwin/manual/index.html
{ config, pkgs, lib, macosUsername, ... }:

let
  secretsFile = ../../secrets/secrets.yaml;
  haveSecretsFile = builtins.pathExists secretsFile;
in
{
  # Set the system architecture for this macOS host
  nixpkgs.hostPlatform = "aarch64-darwin";  # Apple Silicon (change to "x86_64-darwin" for Intel)

  # Set primary user for nix-darwin
  system.primaryUser = macosUsername;

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
    options = "--delete-older-than 5d";
  };

  sops = lib.mkIf haveSecretsFile {
    defaultSopsFile = secretsFile;
    age.keyFile = "/Users/${macosUsername}/.config/sops/age/keys.txt";
    secrets.no_proxy = { };
  };


  # Set proxy environment variables for Nix daemon
  launchd.daemons.nix-daemon.environment = {
    HTTP_PROXY = "http://localhost:3128";
    HTTPS_PROXY = "http://localhost:3128";
    ALL_PROXY = "http://localhost:3128";
  };
  
  # Environment variables
  environment.variables = {
    HTTP_PROXY = "http://localhost:3128";       # Set proxy for user environment (for Homebrew and other tools)
    HTTPS_PROXY = "http://localhost:3128";
    ALL_PROXY = "http://localhost:3128";        # Universal proxy setting (used by curl, Homebrew, etc.)
    
    # Homebrew settings
    HOMEBREW_AUTO_UPDATE_SECS = "864000";       # How often Homebrew auto-update runs (seconds). Example: 86400 = 1 day
    HOMEBREW_NO_AUTO_UPDATE = "1";              # disable auto-update during operations, do it manually via    brew update --auto-update
    #HOMEBREW_NO_INSTALL_CLEANUP = "1";          # Skip cleanup after install (can hang with proxy)
    #HOMEBREW_CASK_OPTS = "--no-quarantine";     # Skip quarantine verification for casks (can timeout with proxy)
    #HOMEBREW_NO_VERIFY_ATTESTATIONS = "1";      # Skip cryptographic verification (requires network)
  };
  
  system.defaults = {

    # Dock
    dock = {
      autohide = false;
      show-recents = false;
      tilesize = 36;
      orientation = "bottom";
      # Hot Corners
      wvous-tr-corner = 12;   # enum: Show open apps
      wvous-br-corner = 2;    # enum: Mission control 
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
      FXPreferredViewStyle = "Nlsv"; # Views: Nlsv (list), icnv (icon), clmv (column), Flwv (cover flow)
      ShowPathbar = true;
      _FXShowPosixPathInTitle = true;
    };

    # Global UI/Input
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;     # Show hidden files in Finder by default

      # Keyboard
      KeyRepeat = 3;                # delay per repeat
      InitialKeyRepeat = 30;        # delay before repeat

      # Trackpad
      "com.apple.trackpad.scaling" = 0.875;  # Standard trackpad speed (range typically 0-3)
      "com.apple.swipescrolldirection" = false;  # Natural scrolling (false = reverse/traditional scrolling)
      
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
      
      # AppleScrollerPagingBehavior = null;  # Jump to the spot that’s clicked on the scroll bar. The default is false.
    };

    # Reduce motion system-wide (less animation for supported UI)
    # universalaccess.reduceMotion = true;

    # Defaults not covered by nix-darwin's typed options
    CustomUserPreferences = {
      "com.apple.dock" = {
        # Disable the sliding animation when switching "Spaces" (workspaces)
        "workspaces-swoosh-animation-off" = true;
        # Speed up Mission Control / Exposé animations
        "expose-animation-duration" = 0.08;
        "mcx-expose-animation-duration" = 0.08;
      };
      
      # Finder-specific keyboard shortcuts
      "com.apple.finder" = {
        NSUserKeyEquivalents = {
          "Rename" = "\UF709";  # F2 key to rename file
        };
      };
    };

    # Disable window tiling as "Rectangle" app is used
    WindowManager.EnableTilingByEdgeDrag = false;
    WindowManager.EnableTopTilingByEdgeDrag = false;
    WindowManager.EnableTilingOptionAccelerator = false;
  };

  # Point Caps Lock to Escape // not done bc. we use it for leader key remap via hidutil
  #system.keyboard = {
  #  enableKeyMapping = true;
  #  remapCapsLockToEscape = true;
  #};

  # Trackpad
  system.defaults.trackpad = {
    #TrackpadThreeFingerVertSwipeGesture = 2;  # Enable three-finger vertical swipe for App Exposé
    TrackpadThreeFingerDrag = true;  # Enable three-finger drag for window management 
  };

  system.activationScripts.noProxyFromSops = lib.mkIf haveSecretsFile {
    deps = [ "nix-daemon" ];
    text = ''
      NO_PROXY_VALUE="$(/bin/cat ${config.sops.secrets.no_proxy.path} | /usr/bin/tr -d '\n' | /usr/bin/xargs)"
      DAEMON_PLIST="/Library/LaunchDaemons/org.nixos.nix-daemon.plist"

      if [ -f "$DAEMON_PLIST" ]; then
        if ! /usr/libexec/PlistBuddy -c "Print :EnvironmentVariables" "$DAEMON_PLIST" >/dev/null 2>&1; then
          /usr/libexec/PlistBuddy -c "Add :EnvironmentVariables dict" "$DAEMON_PLIST"
        fi

        if ! /usr/libexec/PlistBuddy -c "Set :EnvironmentVariables:NO_PROXY $NO_PROXY_VALUE" "$DAEMON_PLIST" >/dev/null 2>&1; then
          /usr/libexec/PlistBuddy -c "Add :EnvironmentVariables:NO_PROXY string $NO_PROXY_VALUE" "$DAEMON_PLIST"
        fi

        if ! /usr/libexec/PlistBuddy -c "Set :EnvironmentVariables:no_proxy $NO_PROXY_VALUE" "$DAEMON_PLIST" >/dev/null 2>&1; then
          /usr/libexec/PlistBuddy -c "Add :EnvironmentVariables:no_proxy string $NO_PROXY_VALUE" "$DAEMON_PLIST"
        fi
      fi
    '';
  };

  # System-wide network proxy settings (for GUI apps like Raycast)
  # Configure proxy on all network interfaces using networksetup
  system.activationScripts.extraActivation.text = ''
    # Set proxy for all known network services
    for service in "Wi-Fi" "Office-WLAN" "Ethernet" "Thunderbolt Bridge"; do
      if /usr/sbin/networksetup -listallnetworkservices | grep -q "^$service$"; then
        echo "Configuring proxy for $service..."
        /usr/sbin/networksetup -setwebproxy "$service" localhost 3128
        /usr/sbin/networksetup -setsecurewebproxy "$service" localhost 3128
        /usr/sbin/networksetup -setproxybypassdomains "$service" localhost 127.0.0.1
      fi
    done
  '';

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
  # power.sleep.allowSleepByPowerButton = null;  
 
}
