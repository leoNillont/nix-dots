{
  description = "leoFlake";

  inputs = {

    # Paquetes oficiales de Nixos (nixpkgs)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # home-manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Disko
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Catppuccin
    catppuccin.url = "github:catppuccin/nix";

  };

  outputs = { self, nixpkgs, home-manager, disko, catppuccin, ... }@inputs: {
    nixosConfigurations = {
      "leopc" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        # importar modulos
	      modules = [
	        # configuracion general
	        ./configuration.nix
          
          # configuracion de host
	        ./hosts/leopc/leopc.nix
	        
	        # modulo de disko
          disko.nixosModules.disko
          ./disko-config.nix

          # Catppuccin
          catppuccin.nixosModules.catppuccin
          
	        # Home Manager
	        home-manager.nixosModules.home-manager
	        {
	          home-manager.useGlobalPkgs = true;
	          home-manager.useUserPackages = true;
	          home-manager.users.leonillo = {
              imports = [
                ./home.nix
                catppuccin.homeManagerModules.catppuccin
              ];
            };
	        }
        ];
      };

    "leolaptop" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        
	      # importar modulos
        modules = [
	        # configuracion general
          ./configuration.nix

          # configuracion de host
          ./hosts/leolaptop/leolaptop.nix

	        # modulo de disko
          disko.nixosModules.disko
          ./disko-config.nix

          # Catppuccin
          catppuccin.nixosModules.catppuccin

          # Home manager
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.leonillo = import ./home.nix;
            catppuccin.homeManagerModules.catppuccin
          }
        ];
      };
    };
  };
}
