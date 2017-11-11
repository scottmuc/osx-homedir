source ~/bin/colours.bash
source ~/bin/git_completion.bash

# ~/bin is the location of personal scripts I would like available everywhere
export PATH="$HOME/bin:$PATH"

# Go 1.8 will default GOPATH to ~/go and I would like to expose the go installed
# tools everywhere
export PATH="$HOME/go/bin:$PATH"

# need this set to xterm-256color to get proper color support in vim
export TERM='xterm-256color'

alias ls='ls -G'
alias ll='ls -lhG'
alias la='ls -lahG'
alias vim='nvim'

export LSCOLORS="GxFxCxDxBxEgEdabagacad"
export GREP_OPTIONS="--color"

# Erase duplicates in history
export HISTCONTROL=erasedups
# Store 10k history entries
export HISTSIZE=10000
# Append to the history file when exiting instead of overwriting it
shopt -s histappend

alias vdu="vagrant destroy -f && vagrant up"
alias q="exit"
alias be="bundle exec"

export EDITOR="vim -f"

PS1="\[${VIOLET}\]\\w \[${GREEN}\]? \[${RESET}\]"

if [ -f /usr/local/opt/chruby/share/chruby/chruby.sh ]; then
  source /usr/local/opt/chruby/share/chruby/chruby.sh
fi

