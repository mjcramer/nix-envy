{
  description = "Cramer's Workstation Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, flake-utils, home-manager, ... }: 
    let
      mySystems = {
        # My personal laptop
        jozibean = {
          system = "x86_64-darwin";
          username = "cramer";
        };
        # My work laptop
        oxford-corp-cramer = {
          system = "aarch64-darwin";
          username = "mjcramer";
        };
      };
      lib = nixpkgs.lib;
      mkDarwinSystem = { system, hostname, username }:
        nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = {
            vars = {
              inherit username;
              inherit hostname;
            };
          };
          modules = [
            ./modules/core.nix
            ./modules/system.nix
            ./modules/apps.nix
            ./modules/users.nix
            home-manager.darwinModules.home-manager {
              home-manager.verbose = true;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "nix-backup";
              home-manager.users.${username} = import ./home;
              home-manager.extraSpecialArgs = {
                vars = {
                  inherit username;
                  inherit hostname;
                };
              };
            }
          ];
        };
    in {
      darwinConfigurations = {
        "jozibean" = mkDarwinSystem { 
          system = "x86_64-darwin";
          hostname = "jozibean";
          username = "cramer";
        };
        "oxford-corp-cramer" = mkDarwinSystem { 
          system = "aarch64-darwin";
          hostname = "oxford-corp-cramer";
          username = "mjcramer";
        };
      };
      # darwinConfigurations = lib.mapAttrs (name: vars: mkDarwinSystem {
      #     hostname = name;
      #     system = vars.system;
      #     username = vars.username;
      # });
        
      # // flake-utils.lib.eachDefaultSystem (system:
      #   let
      #     pkgs = import nixpkgs { inherit system; };
      #   in {
      #     devShells.default = pkgs.mkShell {
      #       buildInputs = [ pkgs.git pkgs.curl pkgs.neovim ];
      #       shellHook = ''echo "Welcome to nix develop shell!"'';
      #     };
      #   }
      # );
  };
}
