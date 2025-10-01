# ./hosts/work/composer.nix
# WSL (headless dev) host composition
{ config, pkgs, inputs, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./configuration.nix
    ./hardware-configuration.nix   # Placeholder; may be removed/ignored in WSL

    ../../modules/system/user.nix
    ../../profiles/system/common.nix
    ../../profiles/system/development-headless.nix
  ];

  # Home Manager wiring (minimal: only common profile)
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";
  home-manager.sharedModules = [
  ];
  # Reuse the shared per-user config (no host-specific home.nix for now)
  home-manager.users.vii.imports = [ ../../home/vii/home.nix ];

  system.stateVersion = "25.05"; # Keep at initial install version
}
