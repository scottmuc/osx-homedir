source ~/bin/colours.bash

export PATH="~/bin:$PATH"
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"

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

# intellij specific
INTELLIJ="~/Applications/IntelliJ\ IDEA\ 13\ CE.app/Contents/MacOS/idea"
alias intellij="${INTELLIJ} &"
alias op="${INTELLIJ} \`pwd\` &"
alias opr="${INTELLIJ} \`pwd\`/\`ls *.ipr\` &"

alias el="vim ~/Dropbox/Docs/lists.yml"
alias vdu="vagrant destroy -f && vagrant up"
alias q="exit"
alias be="bundle exec"
alias play="mp3blaster"

export EDITOR="vim -f"
export JAVA_HOME="/System/Library/Frameworks/JavaVM.framework/Home"

function use_rvm() {
  RVM=`which rvm`
  if [ "$RVM" = "" ]; then
    . "$HOME/.rvm/scripts/rvm"
    PATH=$PATH:$HOME/.rvm/bin
  fi
}

function use_rbenv() {
  RBENV=`which rbenv`
  if [ "$RBENV" = "" ]; then
    PATH=$HOME/.rbenv/bin:$PATH
    eval "$(rbenv init -)"
  fi
}

PS1="\[${VIOLET}\]\\w \[${GREEN}\]? \[${RESET}\]"
PS1="\$(~/.rvm/bin/rvm-prompt) $PS1"

source ~/bin/git_completion.bash

added_keys=`ssh-add -l`

if [ ! $(echo $added_keys | grep -o -e github_rsa) ]; then
    ssh-add "$HOME/.ssh/github_rsa"
fi

