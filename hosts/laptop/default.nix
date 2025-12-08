# ./hosts/laptop/composer.nix
{ config, pkgs, inputs, ... }:

{
  imports =
    [ 
      inputs.home-manager.nixosModules.home-manager
      ./configuration.nix
      ./hardware-configuration.nix

      ../../modules/system/user.nix
      ../../profiles/system/common.nix
      ../../profiles/system/niri.nix
      ../../profiles/system/development-headless.nix
      
      ./swap.nix
      ./nbfc.nix
    ];

  # Home Manager wiring for this host
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";   # backup existing dotfiles before overwriting
  home-manager.extraSpecialArgs = { inherit (config._module.specialArgs) pkgs-unstable; };
  home-manager.sharedModules =
    [
      inputs.nixvim.homeManagerModules.nixvim
      ../../profiles/home/niri.nix
      ../../profiles/home/desktop.nix
      ../../profiles/home/development-desktop.nix
      ../../profiles/home/development-headless.nix
    ];
  home-manager.users.vii.imports = [ ./home.nix ../../home/vii/home.nix ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
