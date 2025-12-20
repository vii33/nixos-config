# ./hosts/home-server/composer.nix
{ config, pkgs, inputs, ... }:

{
  imports =
    [
      inputs.home-manager.nixosModules.home-manager
      ./configuration.nix
      # hardware-configuration.nix
      ../../profiles/system/common_all.nix
      ../../profiles/system/common_linux.nix
      ../../profiles/system/server.nix
    ];

  # Home Manager wiring for this host
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";   # backup existing dotfiles before overwriting
  home-manager.extraSpecialArgs = { inherit (config._module.specialArgs) pkgs-unstable; };
  home-manager.sharedModules =
    [
    ];
  home-manager.users.vii.imports = [ ../../home/vii/home-linux.nix ];

  system.stateVersion = "25.05";

}