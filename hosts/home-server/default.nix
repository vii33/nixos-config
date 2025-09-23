# ./hosts/home-server/default.nix
{ config, pkgs, ... }:

{
  imports =
    [
      ./configuration.nix
      ./packages.nix
    ];

  system.stateVersion = "25.05";

}
