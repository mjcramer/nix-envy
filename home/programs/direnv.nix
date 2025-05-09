{ config, pkgs, lib, ... }: {
 
  home.packages = with pkgs; [
    direnv
  ];

  home.file.".config/direnv/direnv.toml".text = ''
    [global]
      warn_timeout = "30s"
      DIRENV_LOG_FORMAT = "direnv: %s"
  '';
  programs.direnv = {
    enable = true;
    enableBashIntegration = true; 
    # enableFishIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}