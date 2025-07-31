{ config, lib, pkgs, ... }:

{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    enableVteIntegration = true;

    historySize = 500000;
    historyFileSize = 100000;
    historyControl = [
        # Don't save duplicate commands
        "erasedups"
        "ignoreboth"
    ];
    # Don't save these commands
    historyIgnore = [
        "&"
        "[ ]*"
        "exit"
        "ls"
        "bg"
        "fg"
        "history"
        "clear"
    ];

    shellOptions = [
        # Append to the history file, don't overwrite it
        "histappend"
        # Save multi-line commands as one command
        "cmdhist"
        "autocd"
        "dirspell"
        "cdspell"
    ];

    shellAliases = {
      less = "less -r";
      mkdir = "mkdir -pv";
      grep = "grep --color = auto";
      egrep = "egrep --color = auto";
      fgrep = "fgrep --color = auto";
      h = "history";
      j = "jobs -l";
      ping = "ping -c 5";
      pingfast = "ping -c 100 -s.2";
      ls = "lsd";
      vi = "nvim";
      vim = "nvim";
      ll = "lsd -alF";
      gs = "git status";
    };

    sessionVariables = {
        # This defines where cd looks for targets, add the directories you want to have fast access to, separated by colon
        CDPATH = ".:~:~/projects";

    };

    initExtra = ''
      ## Check to see that we have fish...
      if [ -z "$INTELLIJ_ENVIRONMENT_READER" ]; then
        if command -v ${pkgs.fish}/bin/fish >/dev/null 2>&1; then
          exec ${pkgs.fish}/bin/fish -l
        fi
      fi

      # Colors
      reset="\[\e[0m\]"
      bold="\[\e[1m\]"
      red="\[\e[0;31m\]"
      green="\[\e[0;32m\]"
      yellow="\[\e[0;33m\]"
      blue="\[\e[0;34m\]"
      magenta="\[\e[0;35m\]"
      cyan="\[\e[0;36m\]"

      # Set a colorful and fancy Bash prompt
#      PS1="$${bold}$${green}\u$${reset}@$${magenta}\h$${reset}:$${blue}\w$${reset}$${yellow}\$(__git_ps1 ' (%s)')$${reset}\n\$ "
      PS1='\[\e[0;32m\]\u@\h \[\e[0;34m\]\w \[\e[0;36m\]\A\[\e[0m\]\n\[\e[0;37m\]❯ \[\e[0m\]'
    '';

    profileExtra = ''
      # I don't know why nix bash doesn't generate this automatically, but here we are...
      . ~/.nix-profile/etc/profile.d/nix-daemon.sh
    '';
  };
}
# Enable incremental history search with up/down arrows (also Readline goodness)
# Learn more about this here: http://codeinthehole.com/writing/the-most-important-command-line-tip-incremental-history-searching-with-inputrc/
#bind '"\e[A": history-search-backward'
#bind '"\e[B": history-search-forward'
#bind '"\e[C": forward-char'
#bind '"\e[D": backward-char'

##
## TAB-COMPLETION (Readline bindings)
##
# Display matches for ambiguous patterns at first tab press
#bind "set show-all-if-ambiguous on"
