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
          username = "mjcramer";
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
          # config.allowUnfree = true;
          specialArgs = {
            vars = {
              inherit username;
              inherit hostname;
            };
          };
          modules = [
            ./modules/core.nix
            ./modules/system.nix
            ./modules/packages.nix
            ./modules/host.nix
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
        
#      flake-utils.lib.eachDefaultSystem (system:
#      let
#        pkgs = import nixpkgs { inherit system; };
#        shellHook = ''
#          # If not already running Fish, replace the shell with Fish
#          if [ "$SHELL" != "$(which fish)" ]; then
#            exec fish
#          fi
#        '';
#      in {
#        devShells = {
#          default = pkgs.mkShell {
#            buildInputs = [
#              pkgs.jdk21       # Java 8
#              pkgs.scala_3
#            ];
#            inherit shellHook;
#          };
#          nexus-meta = pkgs.mkShell {
#            buildInputs = [
#              pkgs.openjdk8       # Java 8
#              pkgs.scala_2_12     # Scala 2.12
#            ];
#            inherit shellHook;
#          };
#        };
#      }
#    );
  };
}
