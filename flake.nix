{
  description = "My NixOS Dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }: {
    nixosConfigurations = {
      raul-desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/desktop/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.raul = import ./hosts/desktop/home.nix;
          }
        ];
      };
      raul-xps = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/xps/configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.raul = import ./hosts/xps/home.nix;
          }
        ];
      };
      devcontainer = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        modules = [
          ./hosts/devcontainer/configuration.nix
        ];
      };
      # raul-vm = nixpkgs.lib.nixosSystem {
      #   system = "x86_64-linux";
      #   modules = [
      #     ./hosts/vm/configuration.nix
      #
      #     home-manager.nixosModules.home-manager
      #     {
      #       home-manager.useGlobalPkgs = true;
      #       home-manager.useUserPackages = true;
      #       home-manager.users.raul = import ./home.nix;
      #     }
      #   ];
      # };
    };
  };
}
