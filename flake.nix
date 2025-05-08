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
            ./modules/host.nix
            ./modules/users.nix
            ./modules/packages.nix
            ./modules/homebrew.nix
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

        shellHook = ''
          # If not already running Fish, replace the shell with Fish
          if [ "$SHELL" != "$(which fish)" ]; then
            exec fish
          fi
        '';

    in {
      darwinConfigurations = {
        "jozibean" = mkDarwinSystem { 
          system = "x86_64-darwin";
          hostname = "jozibean";
          username = "mjcramer";
        };
        "cramer-adobe-macbook" = mkDarwinSystem { 
          system = "aarch64-darwin";
          hostname = "cramer-adobe-macbook";
          username = "micramer";
        };
      };
        
# flake-utils.lib.eachDefaultSystem (system:
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
      # }
    # );
  };
}
