# ./hosts/home-server/default.nix
{ config, pkgs, inputs, ... }:

{
  imports =
    [
      inputs.home-manager.nixosModules.home-manager
      ./configuration.nix
      # hardware-configuration.nix

      # Common configuration
      ../../modules/system/common_all.nix
      ../../modules/system/common_linux.nix
    ];

  # From profiles/system/server.nix (currently empty, but keeping structure)
  # environment.systemPackages = with pkgs; [
  #   # Add packages here
  # ];

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
