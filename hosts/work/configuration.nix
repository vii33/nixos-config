# ./hosts/work/configuration.nix
# Base WSL-oriented configuration (headless dev). Adjust as needed.
{ config, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "work";  # Hostname for this environment

  # WSL note: Bootloader and most hardware-specific services are not applicable.
  # Add additional services or dev tooling modules as needed.

  # Enable OpenSSH if desired (uncomment below):
  # services.openssh.enable = true;

}
