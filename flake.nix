{
  description = "NixOS config flake for various hosts including macOS";

  nixConfig = {
    allowDirty = true; # no build warnings even with uncommitted changes
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
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    handy = {
      url = "github:cjpais/Handy";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    kanagawa-yazi = {
      # Yazi color theme
      url = "github:dangooddd/kanagawa.yazi";
      flake = false;
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nix-darwin,
      nixvim,
      sops-nix,
      niri,
      handy,
      kanagawa-yazi,
      ...
    }@inputs:
    let
      macosUsername =
        let
          u = builtins.getEnv "MACOS_USERNAME";
          home = builtins.getEnv "HOME";
          homeUser = if home != "" then builtins.baseNameOf home else "";
        in
        if u != "" then
          u
        else if homeUser != "" then
          homeUser
        else
          "vii";
      darwinSystem = "aarch64-darwin";
    in
    {
      nixosConfigurations = {

        laptop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            pkgs-unstable = import nixpkgs-unstable {
              system = "x86_64-linux";
              config = {
                allowUnfree = true;
                permittedInsecurePackages = [
                  # Bitwarden Desktop 2026.5.0 currently depends on Electron 39.
                  "electron-39.8.10"
                ];
              };
            };
          };
          modules = [
            inputs.sops-nix.nixosModules.sops
            inputs.handy.nixosModules.default
            ./hosts/laptop/default.nix
          ];
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
          modules = [
            inputs.sops-nix.nixosModules.sops
            ./hosts/home-server/default.nix
          ];
        };
      };

      darwinConfigurations = {
        work = nix-darwin.lib.darwinSystem {
          system = darwinSystem; # Apple silicon
          specialArgs = {
            inherit inputs;
            inherit macosUsername;
            pkgs-unstable = import nixpkgs-unstable {
              system = darwinSystem;
              config.allowUnfree = true;
            };
          };
          modules = [
            inputs.sops-nix.darwinModules.sops
            ./hosts/work/default.nix
          ];
        };
      };

      formatter = {
        x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
        aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt-rfc-style;
      };

      # Standalone Home Manager configuration for macOS, no sudo needed
      homeConfigurations = {
        work =
          let
            system = darwinSystem;
            pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };
            pkgs-unstable = import nixpkgs-unstable {
              inherit system;
              config.allowUnfree = true;
            };

          in
          home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = {
              inherit inputs pkgs-unstable macosUsername;
              gitIdentity = "work";
            };
            modules = [
              inputs.sops-nix.homeManagerModules.sops
              ./home/vii/home-darwin.nix

              ./modules/home/fish-shell.nix
              ./modules/home/ghostty.nix
              ./modules/home/yazi.nix
              ./modules/home/zellij.nix
              ./modules/home/darwin/capslock-to-f18.nix
              ./modules/home/darwin/aldente-autostart.nix
              #./modules/home/darwin/paneru.nix
            ];
          };
      };
    };
}
