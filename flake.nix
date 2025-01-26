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
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager, ... }: {
    # Build darwin flake using:


#    darwinConfigurations = nixpkgs.lib.genAttrs darwinSystems (system:
#            darwin.lib.darwinSystem {
#              inherit system;
#              specialArgs = inputs;
#              modules = [
#                home-manager.darwinModules.home-manager
#                nix-homebrew.darwinModules.nix-homebrew
#                {
#                  nix-homebrew = {
#                    inherit user;
#                    enable = true;
#                    taps = {
#                      "homebrew/homebrew-core" = homebrew-core;
#                      "homebrew/homebrew-cask" = homebrew-cask;
#                      "homebrew/homebrew-bundle" = homebrew-bundle;
#                    };
#                    mutableTaps = false;
#                    autoMigrate = true;
#                  };
#                }
#                ./hosts/darwin
#              ];
#            }
#          );
#          nixosConfigurations = nixpkgs.lib.genAttrs linuxSystems (system:
#            nixpkgs.lib.nixosSystem {
#              inherit system;
#              specialArgs = inputs;
#              modules = [
#                disko.nixosModules.disko
#                home-manager.nixosModules.home-manager {
#                  home-manager = {
#                    useGlobalPkgs = true;
#                    useUserPackages = true;
#                    users.${user} = import ./modules/nixos/home-manager.nix;
#                  };
#                }
#                ./hosts/nixos
#              ];
#            }
#          );
#        };


    # `darwin-rebuild build --flake .#jozibean`
    darwinConfigurations = {
      "jozibean" = nix-darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        specialArgs = { inherit inputs; };
        modules = [
          ./modules/nix-core.nix
          ./modules/system.nix
          ./modules/apps.nix
          ./modules/host-users.nix

          home-manager.darwinModules.home-manager {
            home-manager.verbose = true;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "nix-backup";
            home-manager.users.cramer = import ./home;
            # home-manager.extraSpecialArgs = {
            #   inherit inputs;
            #   # dotfiles = dotfiles;
            #   # hack around nix-home-manager causing infinite recursion
            #   # isLinux = false;
            # };
          }
        ];
      };
      "oxford-corp-cramer" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit inputs; };
        modules = [
          ./modules/nix-core.nix
          ./modules/system.nix
          ./modules/apps.nix
          ./modules/host-users-2.nix

          home-manager.darwinModules.home-manager {
            home-manager.verbose = true;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "nix-backup";
            home-manager.users.mjcramer = import ./home/default-2.nix;
            # home-manager.extraSpecialArgs = {
            #   inherit inputs;
            #   # dotfiles = dotfiles;
            #   # hack around nix-home-manager causing infinite recursion
            #   # isLinux = false;
            # };
          }
        ];
      };
    };
  };
}
