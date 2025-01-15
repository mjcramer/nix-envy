{ config, inputs, pkgs, lib, ... }:

let 
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
      target = "link";
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
    username = "mjcramer";
    homeDirectory = "/Users/mjcramer";
    stateVersion = "24.11";
  };

  home.file = dotfiles // templates; 

  # home.packages = [
  #   (pkgs.python3.withPackages (ppkgs: [
  #     ppkgs.termcolor
  #     ppkgs.GitPython      
  #     ppkgs.numpy
  #     ppkgs.pytorch
  #   ]))
  # ];

  # Add the scripts to the PATH
  # home.sessionVariables.PATH = "${scripts}/bin:${config.home.sessionVariables.PATH}";

  imports = [
    ./programs/fish.nix
    ./programs/git.nix
    ./programs/htop.nix
    ./programs/vim.nix
    ./programs/zsh.nix
  ];
}