# ./home/programs/fish.nix
{ config, pkgs, lib, ... }: 
let 
  tideConfigure = builtins.concatStringsSep " " [
    "tide configure --auto --style=Rainbow --prompt_colors='True color' --show_time='24-hour format' --rainbow_prompt_separators=Round"
    "--powerline_prompt_heads=Round --powerline_prompt_tails=Sharp --powerline_prompt_style='Two lines, frame' --prompt_connection=Disconnected"
    "--powerline_right_prompt_frame=Yes --prompt_connection_andor_frame_color=Darkest --prompt_spacing=Compact --icons='Many icons' --transient=Yes"
  ];
in {

  programs.fish = {
    enable = true;

    plugins = with pkgs.fishPlugins; [
      { name = "tide"; inherit (tide) src; }
      { name = "done"; inherit (done) src; }
      { name = "grc"; inherit (grc) src; }
      { name = "fzf-fish"; inherit (fzf-fish) src; }
      { name = "z"; inherit (z) src; }
    ];

    functions = {
      cmdline = {
        description = "Show the command line for given process id";  
        body = ''
          for pid in $argv
            ps -p $pid -o command -ww
          end
        '';
      };
      envsource = {
        description = "Source a standard env file and set as fish env variables";
        argumentNames = "envfile";
        body = ''
          if not test -f "$envfile"
              echo "Unable to load $envfile"
              return 1
          end
          while read line
              if not string match -qr '^#|^$' "$line" # skip empty lines and comments
                  if string match -qr '=' "$line" # if `=` in line assume we are setting variable.
                      set item (string split -m 1 '=' $line)
                      set item[2] (eval echo $item[2]) # expand any variables in the value
                      set -gx $item[1] $item[2]
                      echo "Exported key: $item[1]" # could say with $item[2] but that might be a secret
                  else
                      eval $line # allow for simple commands to be run
                  end
              end
          end < "$envfile"
        '';
      };
      fish_title = {
        description = "Set the window title dir or name of git repo";
        body = ''
          basename (git rev-parse --show-toplevel 2>/dev/null || echo $PWD)
        '';
      };
      listening = {
        description = "List the processes listening on each port";  
        body = ''
          # jps -m
          lsof -Pn -i4TCP -sTCP:LISTEN #| awk '{ print $1, $2, $3, $8, $9 }' 
        '';
      };
      search = {
        description = "Search code files for matching regex";
        body = ''
          find $argv[1] -type f -exec grep -EHIn --color=auto $argv[2] {} \;
        '';
      };
      gitignore = {
        description = "Generate gitignore for a type";
        body = ''
          curl -sL https://www.gitignore.io/api/$argv
        '';
      };
    };

    shellInit = ''
    '';

    loginShellInit = ''
    '';

    interactiveShellInit = ''
      set -g fish_greeting "Welcome to the fish, the friendly interactive shell! Please note that this shell is managed by nix..."

      # Set up tide prompt
      set -g tide_left_prompt_items time pwd git 
      set -g tide_right_prompt_items status cmd_duration jobs python kubectl toolbox terraform aws 

      # Common aliases
      alias less='less -r'
      alias mkdir='mkdir -pv'
      alias grep='grep --color=auto'
      alias egrep='egrep --color=auto'
      alias fgrep='fgrep --color=auto'
      alias h='history'
      alias j='jobs -l'
      alias ping='ping -c 5'
      alias pingfast='ping -c 100 -s.2'
      alias ls='lsd'
      alias now='date +"%T"'
      alias vi=nvim
      alias vim=nvim

      # Key bindings
      bind \e\x7f backward-kill-word

      # Enable fish to read .envrc on changing directory 
      direnv hook fish | source
      # But not on any arrow key navigation
      set -g direnv_fish_mode disable_arrow

      # Set up docker completion
      if command -q docker 
        if [ ! -f ~/.config/fish/completions/docker.fish ]
	        docker completion fish > ~/.config/fish/completions/docker.fish
        end  
      end
    '';

    shellInitLast = ''
      # Set up jenv for managing JDK paths
      if test (which jenv)
        jenv init - | source
      end
    '';
  };

  home.sessionPath = [ 
    "/Applications/IntelliJ IDEA.app/Contents/MacOS"
    "/opt/homebrew/bin" 
  ];

  # home.activation.installFonts = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  #   mkdir -p "$HOME/Library/Fonts"
  #   ${toString (builtins.concatStringsSep "\n" mesloFontCopyCommands)}
  # '';

  # We need to run tide configure after activation to set up our prompts
  home.activation.configureTide = lib.hm.dag.entryAfter ["installPackages"] ''
    echo -e "\nTo set up your tide prompt, please run the following command in your fish shell...\n"
    echo -e "${tideConfigure}\n"
  '';
}
