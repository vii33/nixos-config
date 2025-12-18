# ./hosts/work/nix-darwin.nix
# Basic nix-darwin configuration for macOS work host
{ config, pkgs, ... }:
{
  # Set the system architecture for this macOS host
  nixpkgs.hostPlatform = "aarch64-darwin";  # Apple Silicon (change to "x86_64-darwin" for Intel)

  # Enable the Nix daemon (required for multi-user Nix installations)
  services.nix-daemon.enable = true;

  # Basic macOS system defaults (optional, can be customized)
  system.defaults = {
    dock.autohide = true;
    finder.AppleShowAllExtensions = true;
    NSGlobalDomain.AppleShowAllExtensions = true;
  };

  # Programs to enable system-wide
  #programs.zsh.enable = true;  # Default shell on macOS
  #programs.bash.enable = true;
}
