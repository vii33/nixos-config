# ./hosts/work/default.nix
# macOS (darwin) host composition
{ config, pkgs, inputs, ... }:

let
  localConfig = import ../../local-config.nix;
in
{
  imports = [
    inputs.home-manager.darwinModules.home-manager
    ./configuration-nix-darwin.nix

    ../../profiles/system/common_all.nix
    # no deskop.nix as this overlaps too much with the managed MacOS setup
    #../../profiles/system/development-headless.nix
    #./apps.nix
  ];

  # Home Manager wiring
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";
  home-manager.extraSpecialArgs = { 
    inherit (config._module.specialArgs) pkgs-unstable;
    inherit localConfig;
  };
  home-manager.sharedModules = [
  ];
  
  # Reuse the shared per-user config (macOS-specific)
  home-manager.users.${localConfig.macosUsername}.imports = [ ../../home/vii/home-darwin.nix ];

  system.stateVersion = 6; # Used to pin darwin configuration versions to avoid breaking changes.
                           # Updated from time to time. See https://nix-darwin.github.io/nix-darwin/manual/index.html#opt-system.stateVersion
}
