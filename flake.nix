{
  description = "NixOS config flake for various hosts including macOS";

  nixConfig = {
    allowDirty = true;  # no build warnings even with uncommitted changes
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
        url = "github:nix-community/home-manager/release-25.11";
        inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    paneru = {
      url = "github:karinushka/paneru";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, 
              nix-darwin, nixvim, niri, paneru, ... }@inputs:
  {
    nixosConfigurations = {

      laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { 
          inherit inputs;
          pkgs-unstable = import nixpkgs-unstable {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
        };
        modules = [ ./hosts/laptop/default.nix ];
      };

      home-server = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { 
          inherit inputs;
          pkgs-unstable = import nixpkgs-unstable {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
        };
        modules = [ ./hosts/home-server/default.nix ];
      };
    };

    darwinConfigurations = {
      work = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";  # Apple silicon
        specialArgs = { 
          inherit inputs;
          pkgs-unstable = import nixpkgs-unstable {
            system = "aarch64-darwin";
            config.allowUnfree = true;
          };
        };
        modules = [ ./hosts/work/default.nix ];
      };
    };

    # Standalone Home Manager configuration for macOS, no sudo needed 
    homeConfigurations = {
      work = 
      let
        system = "aarch64-darwin";
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        pkgs-unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
        localConfig = import ./local-config.nix;

      in home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { 
          inherit inputs pkgs-unstable localConfig;
        };
        modules = [
          #nixvim.homeModules.nixvim
          ./home/vii/home-darwin.nix

          ./modules/home/fish-shell.nix
          ./modules/home/kitty.nix
          #./modules/home/darwin/paneru.nix
        ];
      };
    };
  };
}
