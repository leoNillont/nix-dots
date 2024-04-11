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

  };

  outputs = { self, nixpkgs, home-manager, disko, ... }@inputs: {
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
        
	# importar modulos
        modules = [
	  # configuracion general
          ./configuration.nix

          # configuracion de host
          ./hosts/leolaptop/leolaptop.nix

	  # modulo de disko
          disko.nixosModules.disko
          ./disko-config.nix

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
