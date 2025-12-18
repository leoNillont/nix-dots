{
  description = "leoNillo's flake";

  outputs = { nixpkgs, home-manager, ... }@inputs: let
    # Shared modules used across all configurations
    sharedModules = [
      ./configuration.nix
      inputs.disko.nixosModules.disko
      inputs.catppuccin.nixosModules.catppuccin
      inputs.stylix.nixosModules.stylix

      { home-manager.extraSpecialArgs = { inherit inputs; }; }
      home-manager.nixosModules.home-manager {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.leonillo = {
            imports = [
              ./home.nix
              inputs.catppuccin.homeModules.catppuccin
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
        modules = sharedModules ++ [ 
          ./hosts/goingmerry/default.nix  
          inputs.nixos-hardware.nixosModules.framework-13-7040-amd
        ];
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

    # NixOS-Hardware, has useful things for hardware support
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Stylix, for themeing
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
