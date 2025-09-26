{
  description = "Laptop config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
        url = "github:nix-community/home-manager/release-25.05";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  
    let
    
      homeManagerModulesHomeserver = [
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;  # install packages to /etc/profiles/
          home-manager.users.vii = import ./home/vii/home.nix;
        }
      ];

      homeManagerModulesLaptop = [
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.vii = {
            imports = [
              ./home/vii/home.nix
              ./hosts/laptop/home.nix
            ];
          };
          home-manager.backupFileExtension = "backup";   # backup existing dotfiles before overwriting
        }
      ];

    in
      {
        nixosConfigurations = {
          
          laptop = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = [ ./hosts/laptop/composer.nix ] ++ homeManagerModulesLaptop;
          };

          home-server = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = [ ./hosts/home-server/composer.nix ] ++ homeManagerModulesHomeserver;
          };
        };
      };
}
