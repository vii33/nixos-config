{ config, pkgs, ... }:

{
  homebrew = {
    enable = true;
    
    onActivation = {
      #cleanup = "zap"; # Deletes brew packages that are no longer in this list
      autoUpdate = true;
      upgrade = true;
    };

    # Brew: terminal tools and packages
    brews = [
      #"mas" # CLI Tool für den Mac App Store (wichtig für masApps)
      "neovim"
      #"pnpm"
      "docker-compose"    # Check installation instructions: https://formulae.brew.sh/formula/docker-compose#default
    ];

    # Cask: macOS GUI applications
    casks = [
      # UTILS ###################################################
      #"visual-studio-code"
      #"obsidian"
      #"bitwarden"
      #"spotify"
      "drawio"
      "rectangle"         # Window Management
      #"tiles"            # Window management (alternative to Rectangle)
      "soundanchor"       # Pin sound output
      "qview"             # Quick image viewer
      "karabiner-elements"# Keyboard remapping
      "tuist"             # Keyboard Cowboy
      "shortcat"          # Control macOS with the keyboard
      "rocket"            # Emoji picker
      "mos"               # Smooth mouse scrolling
      #"battery"
      #"vanilla"          # Menu bar items manager, drains battery (especially bluetooth, use few items)

      # DEV #####################################################
      "kitty"             # Terminal emulator
      "insomnia"
      "docker"
      "syntax-highlight"  # Syntax highlighting for macOS Quick Look. Needs to be opened once manually after install to set up.
      "qlmarkdown"        # Markdown preview in macOS Quick Look. Needs to be opened once manually after install to set up.
      "cyberduck"         # FTP/S3 client
    ];
  };
}