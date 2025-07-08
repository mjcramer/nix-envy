{
  description = "Cramer's Workstation Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };


  outputs = inputs@{ self, nixpkgs, nix-darwin, nixos-wsl, home-manager, flake-utils, ... }: 
    let
      lib = nixpkgs.lib;

      mkDarwinSystem = { system, hostname, username }:
        let
          specialArgs = {
            vars = {
              inherit username;
              homeDirectory = "/Users/${username}";
              inherit hostname;
            };
          };
        in
          nix-darwin.lib.darwinSystem {
            inherit system;
            inherit specialArgs;
            modules = [
              ./modules/core.nix
              ./modules/host.nix
              ./modules/packages.nix
              ./modules/darwin/system.nix
              ./modules/darwin/users.nix
              ./modules/darwin/homebrew.nix
              home-manager.darwinModules.home-manager {
                home-manager.verbose = true;
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.backupFileExtension = "nix-backup";
                home-manager.users.${username} = import ./home;
                home-manager.extraSpecialArgs = specialArgs;
              }
            ];
          };

      mkNixosSystem = { system, hostname, username }:
        let
          specialArgs = {
            vars = {
              inherit username;
              homeDirectory = "/home/${username}";
              inherit hostname;
            };
          };
        in
          lib.nixosSystem {
            inherit system;
            inherit specialArgs;
            modules = [
              nixos-wsl.nixosModules.wsl
              ./modules/nixos/system.nix
              ./modules/nixos/users.nix
              ./modules/nixos/programs.nix
              home-manager.nixosModules.home-manager {
                home-manager.verbose = true;
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.backupFileExtension = "nix-backup";
                home-manager.users.${username} = import ./home;
                home-manager.extraSpecialArgs = specialArgs;
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
      };
        
      nixosConfigurations = {
        nixos = mkNixosSystem { 
          system = "x86_64-linux";
          hostname = "nixos";
          username = "mcramer";
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





