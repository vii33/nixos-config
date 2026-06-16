# ./hosts/work/default.nix
# macOS (darwin) host composition
{
  config,
  pkgs,
  inputs,
  macosUsername,
  ...
}:

{
  imports = [
    # Only System level modules here! Home manager further down. Home Manager modules must be imported at user level
    inputs.home-manager.darwinModules.home-manager
    ./configuration-nix-darwin.nix
    ./brew.nix

    ../../modules/system/common_all.nix
  ];

  # Add packages here only when scripts outside the active user session need them.
  environment.systemPackages = with pkgs; [ ];

  # Home Manager wiring
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";
  home-manager.extraSpecialArgs = {
    inherit (config._module.specialArgs) pkgs-unstable;
    inherit inputs;
    inherit macosUsername;
    gitIdentity = "work";
    zellijDefaultLayout = "startup";
  };
  home-manager.sharedModules = [
    inputs.sops-nix.homeManagerModules.sops
    #inputs.nixvim.homeManagerModules.nixvim

    ../../modules/home/fish-shell.nix
    ../../modules/home/ghostty.nix
    ../../modules/home/yazi.nix
    ../../modules/home/zellij.nix
    ../../modules/home/darwin/capslock-to-f18.nix
    ../../modules/home/darwin/aldente-autostart.nix
    #../../modules/home/nixvim/nixvim.nix
    #../../modules/home/nixvim/lazyvim.nix
    #../../modules/home/darwin/paneru.nix
  ];

  # Home Manager imports for main user
  home-manager.users.${macosUsername}.imports = [
    ../../home/vii/home-darwin.nix
  ];

  system.stateVersion = 6;
  # Used to pin darwin configuration versions to avoid breaking changes.
  # Updated from time to time. See https://nix-darwin.github.io/nix-darwin/manual/index.html#opt-system.stateVersion
}
