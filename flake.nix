{
  description = "leoNillo's flake";

  outputs = { self, nixpkgs, home-manager, disko, catppuccin, chaotic, ... }@inputs: let
    # Shared modules used across all configurations
    sharedModules = [
      ./configuration.nix
      disko.nixosModules.disko
      catppuccin.nixosModules.catppuccin
      chaotic.nixosModules.default

      { home-manager.extraSpecialArgs = { inherit inputs; }; }
      home-manager.nixosModules.home-manager {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.leonillo = {
            imports = [
              ./home.nix
              catppuccin.homeModules.catppuccin
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
        specialArgs = { inherit inputs; };
        modules = sharedModules ++ [ ./hosts/thousandsunny/default.nix ];
      };

      "mobydick" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = sharedModules ++ [ ./hosts/mobydick/default.nix ];
      };

      "goingmerry" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = sharedModules ++ [ ./hosts/goingmerry/default.nix ];
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

    # Chaotic-nyx, has a bunch of bleeding edge packages, used for cachy kernel
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
  };
}
