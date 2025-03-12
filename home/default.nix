{ config, pkgs, lib, vars, ... }:

let 
  username = vars.username;
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
in {
  home = {
    inherit username;
    homeDirectory = "/Users/${username}";
    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "24.11";
  
    # Management of dotfiles and templates
    file = dotfiles // templates; 

    # The home.packages option allows you to install Nix packages into your environment.
    packages = [
      # This is what we are going to use for templating
      pkgs.copier

    # scala
    # sbt
    # maven
    # terraform
    # protobuf
    # tmux
    # tree
    # awscli2
    # google-cloud-sdk
    # coursier
    # jetbrains.idea-ultimate
#    corretto11
#    corretto17
#    corretto21
#    jdk11
#    jdk17
    # jdk21
#    vscode


      # It is sometimes useful to fine-tune packages, for example, by applying
      # overrides. You can do that directly here, just don't forget the
      # parentheses. Maybe you want to install Nerd Fonts with a limited number of
      # fonts?
      #(pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    ];

    #pkgs._1password
    #pkgs._1password-gui

    # Set environment/session variables
    sessionVariables = {
      EDITOR = "vim";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = [
    ./programs/fish.nix
    ./programs/zsh.nix
    ./programs/direnv.nix
    ./programs/git.nix
    ./programs/htop.nix
    ./programs/vim.nix
    ./scripts.nix
  ];

  # home.exitShell = lib.mkIf (config.home.enableUninstall) {
  #   script = ''
  #     echo "Cleaning up dotfiles..."
  #     ${builtins.concatStringsSep "\n" (map (name: "echo Removing $HOME/.${name}") (builtins.attrNames dotfiles))
  #   '';
  # };
}
