{ config, pkgs, lib, ... }: {
 
  home.packages = with pkgs; [
    direnv
  ];

  programs.direnv = {
    enable = true;
    enableBashIntegration = true; 
    # enableFishIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}