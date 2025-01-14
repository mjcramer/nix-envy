{ config, inputs, pkgs, lib, ... }:

let 
  # Directory containing dotfiles that aren't managed by nix
  dotfiles = ./dotfiles;
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
    username = "cramer";
    homeDirectory = "/Users/cramer";
    stateVersion = "24.11";
  };

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

  home.file.".sbt/".source = ./dotfiles/sbt; 
  home.file.".sbt/".recursive = true;

  # home.file.".terraform.d/plugin-cache/".directory = true;
  # home.file.".terraformrc".source = ./dotfiles/terraformrc;
  # home.file.".screenrc".source = ./dotfiles/screenrc;

  programs.fish = import ./programs/fish.nix { inherit pkgs; };
  programs.git = import ./programs/git.nix;
  programs.htop = import ./programs/htop.nix;

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

# We need to run tide configure after activation to set up our prompts
home.activation.configure-tide = lib.hm.dag.entryAfter ["writeBoundary"] ''
  ${pkgs.fish}/bin/fish -c "# tide configure --auto --style=Rainbow --prompt_colors='True color' --show_time='24-hour format' --rainbow_prompt_separators=Round --powerline_prompt_heads=Round --powerline_prompt_tails=Slanted --powerline_prompt_style='Two lines, frame' --prompt_connection=Dotted --powerline_right_prompt_frame=Yes --prompt_connection_andor_frame_color=Darkest --prompt_spacing=Sparse --icons='Many icons' --transient=Yes"
'';
}