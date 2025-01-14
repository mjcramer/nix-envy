{
  description = "Cramer's Macbook";

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
    # `darwin-rebuild build --flake .#jozibean`
    darwinConfigurations = {
      "jozibean" = nix-darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        specialArgs = { inherit inputs; };
        modules = [
          # {
          #   nixpkgs.overlays = [
          #     # pkgs.firefox-bin
          #     inputs.nixpkgs-firefox-darwin.overlay

          #     # use selected unstable packages with pkgs.unstable.xyz
          #     # https://discourse.nixos.org/t/how-to-use-nixos-unstable-for-some-packages-only/36337
          #     # "https://github.com/ne9z/dotfiles-flake/blob/d3159df136294675ccea340623c7c363b3584e0d/configuration.nix"
          #     (final: prev: {
          #       unstable =
          #         import inputs.nixpkgs-unstable { system = prev.system; };
          #     })

          #     (final: prev: {
          #       # pkgs.unstable-locked.<something>
          #       unstable-locked =
          #         import inputs.nixpkgs-locked { system = prev.system; };
          #     })

          #     (final: prev: {
          #       # https://github.com/nix-community/home-manager/issues/1341#issuecomment-1468889352
          #       mkAlias =
          #         inputs.mkAlias.outputs.apps.${prev.system}.default.program;
          #     })

          #   ];
          # }
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
    };
  };
}
