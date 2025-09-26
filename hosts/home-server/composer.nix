# ./hosts/home-server/default.nix
{ config, pkgs, inputs, ... }:

{
  imports =
    [
      inputs.home-manager.nixosModules.home-manager
      ./configuration.nix
      # hardware-configuration.nix
      ../../modules/default.nix
      ../../modules/user.nix
    ];

  # Home Manager wiring for this host
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.sharedModules = import ../../modules/home-manager;
  home-manager.users.vii.imports = [ ../../home/vii/home.nix ];

  system.stateVersion = "25.05";

}
