# /etc/nixos/home/home.nix
{ config, pkgs, specialArgs, ... }:

{
  # Import the home-manager module
  home-manager = {
    # This value is passed from the flake.nix `specialArgs`
    extraSpecialArgs = specialArgs;
    users = {
      # For each user, import their specific home.nix
      "vii" = import ./vii/home.nix;
    };
  };
}