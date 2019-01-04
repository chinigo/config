# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="robbyrussell"

export DISABLE_AUTO_UPDATE=true

COMPLETION_WAITING_DOTS="true"
plugins=(cp dotenv git)

source $ZSH/oh-my-zsh.sh

##
# User configuration
##

export PATH=./bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin:./node_modules/.bin:$HOME/.config/yarn/global/node_modules/.bin:/usr/local/var/homebrew/linked/grass7/grass-base/bin
export MANPATH=/usr/local/var/homebrew/linked/grass7/grass-base/docs/man:$MANPATH
export EDITOR=vim
export GIT_EDITOR='vim'

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

PROMPT='%{$fg[blue]%}$(_collapsed_wd) $(_git_prompt_info) %{$fg[white]%}%# %{$terminfo[white]%}'


# Aliases
alias ll='ls -lAGFh'
alias less='less -fSN'
alias be='bundle exec'

# Script to clear scrollback buffer
function cs() {
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down' 2>1 /dev/null
  return 0
}

# rbenv shims and autocompletion
if type rbenv &> /dev/null; then eval "$(rbenv init -)"; fi

# Bindings
bindkey '^[[1;9D' backward-word
bindkey '^[[1;9C' forward-word

bindkey -r '\el' # Unbind "run command: ls"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
