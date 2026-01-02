{
  description = "Borba NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-25.11.url = "github:NixOS/nixpkgs/nixos-25.11";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      inputs,
      ...
    }:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.caveos = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          ./hosts/caveos/configuration.nix

          home-manager.nixosModules.default
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";

            home-manager.users.borba = import ./home/home.nix;
          }
        ];
      };
    };
}
