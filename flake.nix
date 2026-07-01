{
  description = "Andreas nix-darwin/home-manager configuration.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    darwin.url = "github:lnl7/nix-darwin/nix-darwin-26.05";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      darwin,
      nixpkgs,
      home-manager,
      lanzaboote,
      ...
    }:
    {
      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt;
      nixosConfigurations = {
        agent = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [ ./agent.nix ];
        };
        haxmachine = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/haxmachine.nix
            ./modules/nix.nix
            ./modules/base.nix
            ./modules/desktop-base.nix
            ./modules/desktop-plasma.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.tilde = import ./home.nix;
            }
          ];
        };
        snowdrop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            lanzaboote.nixosModules.lanzaboote
            ./hosts/snowdrop.nix
            ./modules/nix.nix
            ./modules/base.nix
            ./modules/desktop-packages.nix
            ./modules/desktop-base.nix
            ./modules/desktop-plasma.nix
            ./modules/secure-boot.nix
            ./modules/andreas-user.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.andreas = import ./home.nix;
            }
          ];
        };
      };

      darwinConfigurations.pelme = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./darwin.nix
          home-manager.darwinModules.home-manager
          (
            let
              home = import ./home.nix;
            in
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.andreas = home;
            }
          )
        ];
      };
    };

}
