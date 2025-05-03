{
  description = "leoNillo's flake";

  outputs = { self, nixpkgs, home-manager, disko, catppuccin, ... }@inputs: let
    # Shared modules used across all configurations
    sharedModules = [
      ./configuration.nix
      disko.nixosModules.disko
      ./disko-config.nix
      catppuccin.nixosModules.catppuccin

      home-manager.nixosModules.home-manager {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.leonillo = {
            imports = [
              ./home.nix
              catppuccin.homeManagerModules.catppuccin
            ];
          };
        };
      }
    ];
  in {
    # NixOS System Configurations
    nixosConfigurations = {
      "thousandsunny" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = sharedModules ++ [ ./hosts/leopc/leopc.nix ];
      };

      "mobydick" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = sharedModules ++ [ ./hosts/leolaptop/leolaptop.nix ];
      };

      "goingmerry" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = sharedModules ++ [ ./hosts/leoframework/leoframework.nix ];
      };
    };
  };

  inputs = {
    # Official NixOS packages (nixpkgs)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager for user configuration
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Disko for declarative disk partitioning
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Catppuccin theme for NixOS
    catppuccin.url = "github:catppuccin/nix";
  };
}
