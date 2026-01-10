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
  ];

  # === From profiles/system/common_all.nix ===
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  programs.fish.enable = true;
  
  environment.systemPackages = with pkgs; [
    vim
    mtr           # My traceroute
    htop
    fzf
    zoxide        # smart cd (integration handled in home module)
    eza
    ripgrep
    fd
    bat
    git
    yazi
    # From profiles/system/work.nix
    python3
    uv
    flameshot     # Screenshot tool
    imagemagick   # Image manipulation tool
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
    # From profiles/home/work.nix
    ../../modules/home/fish-shell.nix
    ../../modules/home/kitty-hm.nix
  ];
  
  # Home Manager imports for main user
  home-manager.users.${localConfig.macosUsername}.imports = [ 
    ../../home/vii/home-darwin.nix 
  ];

  system.stateVersion = 6; # Used to pin darwin configuration versions to avoid breaking changes.
                           # Updated from time to time. See https://nix-darwin.github.io/nix-darwin/manual/index.html#opt-system.stateVersion
}
