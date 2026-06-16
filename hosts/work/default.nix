# ./hosts/work/default.nix
# macOS (darwin) host composition
{ config, pkgs, inputs, macosUsername, ... }:

{
  imports = [  
    # Only system-level modules here. Home Manager modules are imported at user level.
    inputs.home-manager.darwinModules.home-manager
    ./configuration-nix-darwin.nix
    ./brew.nix

    ../../modules/system/common_all.nix
  ];

  environment.systemPackages = with pkgs; [
    python3
    uv
    nodejs        # Node runtime for npm-installed CLIs like playwright-cli
    bun           # Bun runtime with npm compatibility (needed for Mason)
    tree-sitter   # Tree-sitter CLI (required by nvim-treesitter)
    imagemagick   # Image manipulation tool
    lazygit        # Terminal UI for git commands
    #cargo         # Rust package manager // needed for panerau installation
    #rustc         # Rust compiler // needed for panerau installation
  ];

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

  # Pin nix-darwin configuration defaults; do not change without an upgrade plan.
  system.stateVersion = 6;
}
