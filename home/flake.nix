{
  description = "Michael Cramer's Home";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      systemMap = {
        "x86_64-linux" = {
          mkHomeDirectory = username: "/home/${username}";
          modules = [ ./linux.nix ];
        };
        "aarch64-darwin" = {
          mkHomeDirectory = username: "/Users/${username}";
          modules = [ ./darwin.nix ];
        };
        "x86_64-darwin" = {
          mkHomeDirectory = username: "/Users/${username}";
          modules = [ ./darwin.nix ];
        };
      };

      mkHomeConfiguration = { system, username, hostname }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system; };
          extraSpecialArgs = {
            vars = {
              inherit username;
              homeDirectory = systemMap.${system}.mkHomeDirectory username;
              inherit hostname;
            };
          };
          modules = [
           ./.
          ] ++ systemMap.${system}.modules;
        };
    in {
      homeConfigurations = {
        "NeueHealth" = mkHomeConfiguration {
          system = "x86_64-linux";
          username = "mcramer";
          hostname = "NH-C3W3SG3-W";
        };
      };
    };
}