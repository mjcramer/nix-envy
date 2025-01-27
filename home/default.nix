{ config, pkgs, vars, ... }:

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
  
  templates = {
    "templates" = {
      source = ./templates;
      recursive = true;
    };
  };

  # Read all script files and create Nix scripts
  scriptsDir = ./scripts;
  # scripts = pkgs.buildEnv {
  #   name = "scripts";
  #   paths = lib.concatMap (scriptFile: [
  #     (pkgs.writeShellScriptBin (lib.strings.removeSuffix ".sh" (lib.strings.baseName scriptFile)) (builtins.readFile "${scriptsDir}/${scriptFile}"))
  #   ]) (builtins.attrValues (builtins.readDir scriptsDir));
  # };
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
    # packages = [
    #   # Adds the 'hello' command to your environment. It prints a friendly
    #   # "Hello, world!" when run.
    #   pkgs.hello

    #   # It is sometimes useful to fine-tune packages, for example, by applying
    #   # overrides. You can do that directly here, just don't forget the
    #   # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    #   # fonts?
    #   (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    #   # You can also create simple shell scripts directly inside your
    #   # configuration. For example, this adds a command 'my-hello' to your
    #   # environment:
    #   (pkgs.writeShellScriptBin "my-hello" ''
    #     echo "Hello, ${config.home.username}!"
    #   '')
    # ];

    # Set environment/session variables
    # home.sessionVariables.PATH = "${scripts}/bin:${config.home.sessionVariables.PATH}";
    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = [
    ./programs/fish.nix
    ./programs/zsh.nix
    ./programs/git.nix
    ./programs/htop.nix
    ./programs/vim.nix
  ];
}
