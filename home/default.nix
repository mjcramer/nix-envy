{ config, inputs, pkgs, lib, ... }:

let dotfiles = "something"; # inputs.dotfiles;
in {

  home = {
    username = "cramer";
    homeDirectory = "/Users/cramer";
    stateVersion = "24.11";

    # file.".terraform.d/plugin-cache/".directory = true;
    # file.".terraformrc".source = ./dotfiles/terraformrc;
  };
  home.file.".sbt/".source = ./dotfiles/sbt; 
  home.file.".sbt/".recursive = true;     


  programs.git = {
    enable = true;
    userName = "Michael Cramer";
    userEmail = "mjcramer@gmail.com";
    aliases = {
      unstage = "reset HEAD";
      undo-commit = "reset --soft HEAD^";
      poh = "push origin HEAD";
      puh = "pull origin HEAD";
      set-upstream = "!git branch --set-upstream-to=origin/`git symbolic-ref --short HEAD`";
    };

    extraConfig = {
      core = {
        editor = "vim";
        autocrlf = "input";
        excludesfile = "/Users/cramer/.gitignore_global";
      };
      color = { 
      	ui = true;
      };
      init = {
	      defaultBranch = "main";
      };
      push = { 
        autoSetupRemote = true; 
      	default = "current";
      };
      pull = { 
        rebase = true;
      };
      branch = { 
      	autosetuprebase = "always";
      };
      diff = { 
        tool = "bcomp";
      };
      difftool = { 
      	prompt = false;
        bcomp = {
          trustExitCode = true;
          cmd = "/usr/local/bin/bcomp $LOCAL $REMOTE";
        };
      };
      merge = {
        tool = "bcomp";
      };
      mergetool = {
        prompt = false;
        bcomp = {
          trustExitCode = true;
          cmd = "/usr/local/bin/bcomp $LOCAL $REMOTE $BASE $MERGED";
        };
      };
      filter = {
        lfs = {
          clean = "git-lfs clean -- %f";
          smudge = "git-lfs smudge -- %f";
          process = "git-lfs filter-process";
          required = true;
        };
      };  
      url = {
        "ssh://git@github.com/" = {
        	insteadOf = "https://github.com/";
        };
      };
    };
  };








  # imports = [
  #   ./link-home-manager-installed-apps.nix
  #   ./docker.nix
  #   ./gw.nix
  #   ./gpg.nix
  #   ./fonts.nix
  #   (inputs.nix-home-manager + "/modules")
  # ];

  # programs.t-firefox = {
  #   enable = true;
  #   package = pkgs.firefox-devedition-bin;
  #   extraEngines = (import ./firefox-da.nix { });
  # };
  # programs.t-doomemacs.enable = true;
  # programs.t-nvim.enable = true;
  # programs.t-terminal.alacritty = {
  #   enable = true;
  #   package = pkgs.unstable.alacritty;
  # };
  # programs.t-tmux.enable = true;
  # programs.t-zoxide.enable = true;
  # programs.t-shell-tooling.enable = true;
  # programs.t-git = {
  #   enable = true;
  #   # gh version >2.40.0
  #   # https://github.com/cli/cli/issues/326
  #   ghPackage = pkgs.unstable.gh;
  # };

  # # https://github.com/NixOS/nixpkgs/blob/master/pkgs/os-specific/darwin/
  # home.packages = with pkgs; [
  #   coreutils

  #   openconnect

  #   ollama

  #   pkgs.unstable.yabai
  #   pkgs.unstable.skhd
  # ];

  # # TODO hardware.keyboard.zsa.enable

  # home.file = {
  #   ".config/dotfiles".source = dotfiles;
  #   ".config/dotfiles".onChange = ''
  #     echo "Fixing swiftbar path"
  #     /usr/bin/defaults write com.ameba.Swiftbar PluginDirectory \
  #       $(/etc/profiles/per-user/torgeir/bin/readlink ~/.config/dotfiles)/swiftbar/scripts
  #     echo swiftbar plugin directory is $(/usr/bin/defaults read com.ameba.Swiftbar PluginDirectory)
  #   '';

  #   "Library/KeyBindings/DefaultKeyBinding.dict".source = dotfiles
  #     + "/DefaultKeyBinding.dict";

  #   ".ideavimrc".source = dotfiles + "/ideavimrc";

  #   ".yabairc".source = dotfiles + "/yabairc";
  #   ".yabairc".onChange =
  #     "/etc/profiles/per-user/torgeir/bin/yabai --restart-service";

  #   ".skhdrc".source = dotfiles + "/skhdrc";
  #   ".skhdrc".onChange =
  #     "/etc/profiles/per-user/torgeir/bin/skhd --restart-service";
}
