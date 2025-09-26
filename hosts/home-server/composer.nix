# ./hosts/home-server/default.nix
{ config, pkgs, ... }:

{
  imports =
    [
      ./configuration.nix
      # hardware-configuration.nix
      ../../modules/default.nix
      ../../modules/user.nix
    ];

  system.stateVersion = "25.05";

}
