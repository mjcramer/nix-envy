{ pkgs, lib, ... }: {

  nix = {
    settings = {
      # Enable flakes globally
      experimental-features = [ "nix-command" "flakes" ];
      # gets rid of duplicate store files turned off due to
      # https://github.com/NixOS/nix/issues/7273#issuecomment-1325073957
      auto-optimise-store = false;
    };
    package = pkgs.nix;
    gc = {
      automatic = lib.mkDefault true;
      options = lib.mkDefault "--delete-older-than 7d";
    };
  };

  programs.nix-index.enable = true;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = _: true;
}
