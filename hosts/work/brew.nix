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
      "rocket"            # Emoji picker
      #"battery"
      #"vanilla"          # Menu bar items manager, drains battery (especially bluetooth, use few items)
      "nikitabobko/tap/aerospace"  # Tiling window manager // Alternative: yabai + skhd
      "leader-key"        # vim like keybindings - https://github.com/mikker/LeaderKey
      "raycast"           # Spotlight replacement // Alternative: alfred
      "macs-fan-control"
      
      # DEV #####################################################
      "kitty"             # Terminal emulator
      "insomnia"
      "docker"
      "syntax-highlight"  # Syntax highlighting for macOS Quick Look. Needs to be opened once manually after install to set up.
      "qlmarkdown"        # Markdown preview in macOS Quick Look. Needs to be opened once manually after install to set up.
      "cyberduck"         # FTP/S3 client
      "keyclu"          # Show shortcuts for current app
    ];
  };
}  