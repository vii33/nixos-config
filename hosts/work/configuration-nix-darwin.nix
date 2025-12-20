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

  # Set proxy environment variables for Nix daemon
  launchd.daemons.nix-daemon.environment = {
    HTTP_PROXY = "http://localhost:3128";
    HTTPS_PROXY = "http://localhost:3128";
  };

  # Basic macOS system defaults (optional, can be customized)
  system.defaults = {
    dock.autohide = false;
    finder.AppleShowAllExtensions = true;
    NSGlobalDomain.AppleShowAllExtensions = true;
  };

  # Programs to enable system-wide
  #programs.zsh.enable = true;  # Default shell on macOS
  #programs.bash.enable = true;
}
