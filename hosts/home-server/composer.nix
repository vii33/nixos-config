# ./hosts/home-server/composer.nix
{ config, pkgs, inputs, ... }:

{
  imports =
    [
      inputs.home-manager.nixosModules.home-manager
      ./configuration.nix
      # hardware-configuration.nix
      ../../modules/system/user.nix
      ../../profiles/system/common.nix
      ../../profiles/system/server.nix
    ];

  # Home Manager wiring for this host
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";   # backup existing dotfiles before overwriting
  home-manager.sharedModules =
    [
      ../../profiles/home/common.nix
    ];
  home-manager.users.vii.imports = [ ../../home/vii/home.nix ];

  system.stateVersion = "25.05";

}