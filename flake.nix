{
  description = "leoFlake";

  inputs = {

    # Official NixOS package source
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # home-manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {
      "leopc" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

	modules = [
	  ./configuration.nix
	  ./hosts/leopc.nix

	  # Home Manager
	  home-manager.nixosModules.home-manager
	  {
	    home-manager.useGlobalPkgs = true;
	    home-manager.useUserPackages = true;
	    home-manager.users.leonillo = import ./home.nix;
	  }
        ];
      };

      "leolaptop" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./configuration.nix
          ./hosts/leolaptop.nix

          # Home manager
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.leonillo = import ./home.nix;
          }
        ];
      };
    };
  };
}
