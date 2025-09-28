{
  description = "Laptop config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
        url = "github:nix-community/home-manager/release-25.05";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:   # make specific inputs (self, nixpkgs..) from the inputs attribut set available, addtionally put the entire attribute set in the inputs variable
  {
    nixosConfigurations = {

      laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };        # make inputs available in (sub)modules
        modules = [ ./hosts/laptop/composer.nix ];
      };

      home-server = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };       # make inputs available in (sub)modules
        modules = [ ./hosts/home-server/composer.nix ];
      };

      work = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";  # WSL environment (headless dev)
        specialArgs = { inherit inputs; };
        modules = [ ./hosts/work/composer.nix ];
      };
    };
  };
}
