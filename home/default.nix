{ config, pkgs, lib, vars, ... }:

let 
  # Pass in username and hostname 
  username = vars.username;
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
in {
  home = {
    inherit username;
    homeDirectory = lib.mkDefault "/Users/${username}";
    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "25.05";
  
    # Management of dotfiles and templates
    file = dotfiles // templates; 

    # The home.packages option allows you to install Nix packages into your environment.
    packages = with pkgs; [
      # This is what we are going to use for templating
      copier
      openssh 
      nerd-fonts.meslo-lg
      fd # more better find for activation scripts
      kubectl
    #  karabiner-elements # device (keyboard, mouse, etc.) mapping
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
    # (vscode-with-extensions.override {
    #   vscodeExtensions = with vscode-extensions; [
    #     bbenoist.nix
    #     ms-python.python
    #     ms-azuretools.vscode-docker
    #     ms-vscode-remote.remote-ssh
    #   ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    #     {
    #       name = "remote-ssh-edit";
    #       publisher = "ms-vscode-remote";
    #       version = "0.47.2";
    #       sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
    #     }
    #   ];
    # })
#    corretto11
#    corretto17
#    corretto21
#    jdk11
#    jdk17
    # jdk21
#    vscode
    ];

    # Set environment/session variables
    sessionVariables = {
      EDITOR = "vim";
    };

    # activation.setWallpaper = lib.hm.dag.entryAfter ["linkGeneration"] (builtins.readFile ./helpers/set-wallpapers.sh);

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
    ./programs/fish.nix
    ./programs/zsh.nix
    ./programs/direnv.nix
    ./programs/git.nix
    ./programs/htop.nix
    ./programs/vim.nix
    ./scripts.nix
  ];
}
