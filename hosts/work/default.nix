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

    ../../modules/system/common_all.nix
  ];

  environment.systemPackages = with pkgs; [
    python3
    uv
    bun           # Bun runtime with npm compatibility (needed for Mason)
    imagemagick   # Image manipulation tool
    cargo         # Rust package manager // needed for panerau installation
    rustc         # Rust compiler // needed for panerau installation
    #warpd         # Modal keyboard-driven mouse pointer control
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
    #inputs.nixvim.homeManagerModules.nixvim

    ../../modules/home/fish-shell.nix
    ../../modules/home/kitty.nix
    #../../modules/home/nixvim/nixvim.nix
    #../../modules/home/nixvim/lazyvim.nix
    #../../modules/home/darwin/paneru.nix
    ../../modules/home/yazi.nix
    ../../modules/home/darwin/capslock-to-f18.nix
    ../../modules/home/darwin/aldente-autostart.nix
    #../../modules/home/warpd.nix
    #../../modules/home/darwin/paneru.nix
  ];
  
  # Home Manager imports for main user
  home-manager.users.${localConfig.macosUsername}.imports = [ 
    ../../home/vii/home-darwin.nix 
  ];

  system.stateVersion = 6; # Used to pin darwin configuration versions to avoid breaking changes.
                           # Updated from time to time. See https://nix-darwin.github.io/nix-darwin/manual/index.html#opt-system.stateVersion
}
