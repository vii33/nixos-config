{ config, pkgs, ... }:

{
  homebrew = {
    enable = true;
    
    onActivation = {
      #cleanup = "zap";   # Uninstalls brew packages that are no longer in this list
      autoUpdate = true;
      upgrade = true;
    };

    # Brew: terminal tools and packages. Check for further brew options: https://nix-darwin.github.io/nix-darwin/manual/#opt-homebrew.brews
    brews = [
      "neovim"
      #"pnpm"
      "docker-compose"    # Check installation instructions: https://formulae.brew.sh/formula/docker-compose#default
    ];

    # Cask: macOS GUI applications
    casks = [
      # UTILS ###################################################
      #"visual-studio-code"  # TODO: Check if auto-updates work with brew version
      #"obsidian"         # TODO: Check if auto-updates work with brew version
      #"bitwarden"        # TODO: Check if auto-updates work with brew version
      #"spotify"
      "drawio"
      "rectangle"         # Window Management
      #"tiles"            # Window management (alternative to Rectangle)
      "soundanchor"       # Pin sound output
      #"karabiner-elements"# Keyboard remapping
      "shortcat"          # Control macOS with the keyboard
      #"rocket"           # Emoji picker  // Not needed as done with leader-key and raycast
      "aldente"           # Optimize battery health (80% charge limit) - Alternative: battery (Does not work well with managed MacOS)
      "jordanbaird-ice"   # Hide menu bar items // Alternative: vanilla (needs screen recording permission .-/)
      "nikitabobko/tap/aerospace"  # Tiling window manager // Alternative: paneru (via nixos!812320)
      "leader-key"        # vim like keybindings - https://github.com/mikker/LeaderKey
      "raycast"           # Spotlight replacement // Alternative: alfred
      "macs-fan-control"  # Fan conrol for Mac Notebooks
      "mac-mouse-fix"     # Mouse gestures
      #"linearmouse"    
      
      # DEV #####################################################
      "kitty"             # Terminal emulator
      "bruno"             # API client / Alternative: insomnio
      "docker-desktop"
      #"syntax-highlight"  # Syntax highlighting for macOS Quick Look. Needs to be opened once manually after install to set up. // Deprecated?
      #"qlmarkdown"        # Markdown preview in macOS Quick Look. Needs to be opened once manually after install to set up.  // Deprecated?
      "cyberduck"         # FTP/S3 client
    ];
  };
}  