# ./hosts/work/default.nix
# macOS (darwin) host composition
{ config, pkgs, inputs, ... }:

let
  localConfig = import ../../local-config.nix;
in
{
  imports = [  
    # Only System level modules here! Home manager further down. Home Manager modules must be imported at user level
    inputs.home-manager.darwinModules.home-manager
    ./configuration-nix-darwin.nix
    ./brew.nix

    ../../profiles/system/common_all.nix
    ../../profiles/system/work.nix
  ];

  # Home Manager wiring
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";
  home-manager.extraSpecialArgs = { 
    inherit (config._module.specialArgs) pkgs-unstable;
    inherit inputs;
    inherit localConfig;
  };
  home-manager.sharedModules = [
    inputs.nixvim.homeManagerModules.nixvim
  ];
  
  # Home Manager imports for main user
  home-manager.users.${localConfig.macosUsername}.imports = [ 
    ../../home/vii/home-darwin.nix 
    ../../profiles/home/work.nix
  ];

  system.stateVersion = 6; # Used to pin darwin configuration versions to avoid breaking changes.
                           # Updated from time to time. See https://nix-darwin.github.io/nix-darwin/manual/index.html#opt-system.stateVersion
}
