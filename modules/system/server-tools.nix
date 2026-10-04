# Shared tools and Home Manager configuration for the two server VMs.
{
  config,
  pkgs,
  pkgs-unstable,
  herdr,
  inputs,
  lib,
  serverFlakeHost,
  ...
}:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    # Common configuration
    ../../modules/system/common_all.nix
    ../../modules/system/common_linux.nix
    ./opencode-server.nix
  ];

  _module.args.serverUser = "vii";

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

  # The shared Fish abbreviations otherwise target the laptop configuration.
  home-manager.users.vii.programs.fish.shellAbbrs = {
    nixswitch = lib.mkForce "nh os switch ~/repos/nixos-config/ -H ${serverFlakeHost}";
    nixdry = lib.mkForce "nh os dry-run ~/repos/nixos-config/ -H ${serverFlakeHost}";
  };

}
