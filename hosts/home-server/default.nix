# ./hosts/home-server/default.nix
{
  config,
  pkgs,
  pkgs-unstable,
  herdr,
  inputs,
  ...
}:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./configuration.nix
    ./hardware-configuration.nix

    # Common configuration
    ../../modules/system/common_all.nix
    ../../modules/system/common_linux.nix
    ../../modules/system/ollama.nix
  ];

  # From profiles/system/server.nix (currently empty, but keeping structure)
  environment.systemPackages = [
    pkgs.python3
    pkgs.uv
    pkgs-unstable.codex
    pkgs.docker_29
    pkgs.docker-compose
  ];
  # Run container workloads on the home server.
  virtualisation.docker = {
    enable = true;
    package = pkgs.docker_29;
  };
  users.users.vii.extraGroups = [
    "docker" # Allow vii to manage Docker without sudo.
  ];

  # Home Manager wiring for this host
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup"; # backup existing dotfiles before overwriting
  home-manager.extraSpecialArgs = {
    inherit (config._module.specialArgs) pkgs-unstable inputs;
    gitIdentity = "personal";
  };
  home-manager.sharedModules = [
    inputs.sops-nix.homeManagerModules.sops
    ../../modules/home/fish-shell.nix
    ../../modules/home/fish-keep-awake.nix
    ../../modules/home/herdr.nix
    ../../modules/home/helix.nix
    ../../modules/home/yazi.nix
  ];
  home-manager.users.vii.imports = [ ../../home/vii/home-linux.nix ];
  home-manager.users.vii.home.packages = with pkgs; [
    pkgs-unstable.opencode
    herdr
    lazygit
    trash-cli
  ];

  system.stateVersion = "25.05";

}
