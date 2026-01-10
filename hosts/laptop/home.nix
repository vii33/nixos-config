{  config, pkgs, pkgs-unstable, ... }:

{
  # Host-specific Home Manager overrides for laptop go here.
  # Shared modules are provided via `home-manager.sharedModules` in default.nix
  
  # Packages from profiles/home/desktop.nix
  home.packages = with pkgs; [
    brave
    obsidian
    bitwarden-desktop
    signal-desktop-bin
    thunderbird
    vlc
    # From profiles/home/development-desktop.nix
    pkgs-unstable.vscode
    # From profiles/home/development-headless.nix
    pkgs-unstable.opencode
    pkgs-unstable.github-copilot-cli
  ];
}
