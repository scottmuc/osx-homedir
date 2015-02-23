source ~/bin/colours.bash
source ~/bin/git_completion.bash

export GOPATH=~/code/go-projects

export PATH="~/bin:$PATH"
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
export PATH="$GOPATH/bin:$PATH"

# need this set to xterm-256color to get proper color support in vim
export TERM='xterm-256color'

alias ls='ls -G'
alias ll='ls -lhG'
alias la='ls -lahG'
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
export JAVA_HOME="/System/Library/Frameworks/JavaVM.framework/Home"

eval $(boot2docker shellinit 2>/dev/null)

PS1="\[${VIOLET}\]\\w \[${GREEN}\]? \[${RESET}\]"

