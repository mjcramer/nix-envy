{ config, pkgs, lib, vars, ... }:

let 
  # Pass in username and hostname 
  username = vars.username;
  homeDirectory = vars.homeDirectory;
  hostname = vars.hostname;

  # Directory containing dotfiles that aren't managed by nix
  dotfilesDir = ./dotfiles;
  dotfileNames = builtins.attrNames (builtins.readDir dotfilesDir);
  dotfiles = builtins.listToAttrs (map (name: {
    name = ".${name}";
    value = {
      source = "${dotfilesDir}/${name}";
      recursive = true; # This has no effect if its a file
    };
  }) dotfileNames);
  # Directory containing `copier` templates
  templates = {
    "templates" = {
      source = ./templates;
      recursive = true;
    };
  };
  isWSL = builtins.pathExists /proc/sys/fs/binfmt_misc/WSLInterop;
in {
  home = {
    inherit username;
    inherit homeDirectory;

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "24.05";

    # Management of dotfiles and templates
    file = dotfiles // templates;

    # The home.packages option allows you to install Nix packages into your environment.
    packages = with pkgs; [
      # This is what we are going to use for templating
      copier
      # This is required for fish shell
      fzf
      grc
      jq # json query
      lsd # much better ls
      nil # nix language server
      openssh
      nerd-fonts.meslo-lg
      fd # more better find for activation scripts
      tree
      unzip
      wslu
    ];
#    lib.optionals (!isWSL) [
#      neovim
#    ] ++
#    lib.optionals isWSL [
#      wslu
#    ];

    # Set environment/session variables
    sessionVariables = {
      EDITOR = "nvim";
    };

    activation.generateSSHKey = lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [ ! -f ~/.ssh/id_ed25519 ]; then
        mkdir -p ~/.ssh
        chmod 700 ~/.ssh
        ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N "" -C "${username}@${hostname}"
      fi
    '';
  };

  fonts.fontconfig.enable = true;
  
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = [
    ./programs/bash.nix
    ./programs/fish.nix
    # TODO: Fix broken zsh on wsl
#    ./programs/zsh.nix
    ./programs/direnv.nix
    ./programs/git.nix
    ./programs/htop.nix
    ./programs/vim.nix
    ./scripts.nix
  ];
}
