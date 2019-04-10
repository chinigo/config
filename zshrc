[[ -f $HOME/.profile ]] && source $HOME/.profile

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="robbyrussell"

# Set to this to use case-sensitive completion
CASE_SENSITIVE="false"

# Comment this out to disable weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
plugins=(cp dotenv git virtualenv)

source $ZSH/oh-my-zsh.sh

# Encourage tmux and vim to display colors sanely
export TERM=xterm-256color

##
# User configuration
##

eval `MANPATH= PATH= /usr/libexec/path_helper`

path=(
  ./bin
  ${HOME}/.rbenv/shims
  ${HOME}/.cargo/bin
  /usr/local/sbin
  "$path[@]"
  /usr/local/var/homebrew/linked/osgeo-grass/grass-base/bin
  /usr/local/Cellar/osgeo-gdal-python/2.4.1/bin
)

manpath=(
  "$manpath[@]"
  /usr/local/var/homebrew/linked/osgeo-grass/grass-base/docs/man/
)

export EDITOR=vim
export GIT_EDITOR=vim

# Command prompt
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}"

function _git_prompt_info() {
 ref=$(git symbolic-ref HEAD 2> /dev/null) || return
 echo "$(parse_git_dirty)[$(current_branch)]"
}

_collapsed_wd() {
  echo $(pwd | perl -pe "s|^$HOME|~|g; s|/([^/]{1})[^/]*(?=/)|/\$1|g")
}

PROMPT='%{$fg[blue]%}$(_collapsed_wd) $(virtualenv_prompt_info)$(_git_prompt_info) %{$fg[white]%}%# %{$terminfo[white]%}'


# Aliases
alias df='df -h'
alias ll='ls -lAGFh'
alias less='less -fSN'
alias be='bundle exec'
alias ping='prettyping --nolegend'
alias mrename="sed 's#\(.*\)#mv \"\1\" \"\1\"#' | sort | sudo vim '+Tabularize/\"\zs \"/l0' -"
alias countdirs="find . -maxdepth 1 -type d -print0 | sort -z | xargs -0 -L1 du -hs"

# Script to clear scrollback buffer
function cs() {
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down' 2>1 /dev/null
  return 0
}

# Bindings
bindkey '^[[1;9D' backward-word
bindkey '^[[1;9C' forward-word

bindkey -r '\el' # Unbind "run command: ls"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Configure Python
export PIPENV_VENV_IN_PROJECT=true

eval "$(direnv hook zsh)"
