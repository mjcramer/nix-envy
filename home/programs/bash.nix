#!/bin/bash

if [ "$BASH_SOURCE" = "$0" ]; then
    echo "This script can only be sourced."
    exit 1
fi

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

##
## GENERAL OPTIONS 
##

# Prevent file overwrite on stdout redirection
# Use `>|` to force redirection to an existing file
set -o noclobber

# Update window size after every command
shopt -s checkwinsize

# Enable history expansion with space
# E.g. typing !!<space> will replace the !! with your last command
bind Space:magic-space

# Turn on recursive globbing (enables ** to recurse all directories)
shopt -s globstar 2> /dev/null

##
## HISTORY OPTIONS 
##

# Don't put duplicate lines or lines starting with space in the history.
HISTCONTROL="erasedups:ignoreboth"

# Don't record some commands
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"

# Useful timestamp format
HISTTIMEFORMAT='%F %T '

# Huge history. Doesn't appear to slow things down, so why not?
HISTSIZE=500000
HISTFILESIZE=100000

# Append to the history file, don't overwrite it
shopt -s histappend

# Save multi-line commands as one command
shopt -s cmdhist

# Enable incremental history search with up/down arrows (also Readline goodness)
# Learn more about this here: http://codeinthehole.com/writing/the-most-important-command-line-tip-incremental-history-searching-with-inputrc/
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\e[C": forward-char'
bind '"\e[D": backward-char'

##
## TAB-COMPLETION (Readline bindings) 
##

# Display matches for ambiguous patterns at first tab press
bind "set show-all-if-ambiguous on"

##
## DIRECTORY NAVIGATION 
##

# Prepend cd to directory names automatically
shopt -s autocd 2> /dev/null

# Correct spelling errors during tab-completion
shopt -s dirspell 2> /dev/null

# Correct spelling errors in arguments supplied to cd
shopt -s cdspell 2> /dev/null

# This defines where cd looks for targets
# Add the directories you want to have fast access to, separated by colon
# Ex: CDPATH=".:~:~/projects" will look for targets in the current working directory, in home and in the ~/projects folder
CDPATH="."

# Set a colorful and fancy Bash prompt
PS1='\[\e[0;32m\]\u@\h \[\e[0;34m\]\w \[\e[0;36m\]\A\[\e[0m\]\n\[\e[0;37m\]❯❯❯ \[\e[0m\]'

# Add colors for `ls` command
export LS_COLORS="di=34:ln=36:so=35:pi=33:ex=32:bd=34;46:cd=34;43:su=37;41:sg=30;43:tw=30;42:ow=30;43"

# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Set up path
export PATH=/usr/bin:/usr/sbin:/bin:/sbin:$PATH	
case $(uname -s) in
	Linux)
		# Set additional path elements
		;;

	Darwin)
		CLICOLOR=1
		export LSCOLORS=Exfxcxdxbxegedabagacad

		# Enable bash completion for homebrew
		if [ -n "$(which brew)" ]; then
		    export PATH=/usr/local/bin:/usr/local/sbin:$PATH
            if [ -f $(brew --prefix)/etc/bash_completion ]; then
			    . $(brew --prefix)/etc/bash_completion
            fi
		fi
		;;
esac
