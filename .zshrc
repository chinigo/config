export XDG_CONFIG_HOME=${HOME}/.config

# Path to your oh-my-zsh configuration.
ZSH=${XDG_CONFIG_HOME}/oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="robbyrussell"

# Set to this to use case-sensitive completion
CASE_SENSITIVE="false"

# Comment this out to disable weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
export ZSH_DISABLE_COMPFIX=true

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
plugins=(docker docker-compose git)

source ${ZSH}/oh-my-zsh.sh

##
# User configuration
##

# Environment variables

export EDITOR=nvim
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
export GIT_EDITOR=nvim
export KEYTIMEOUT=1 # Reduce delay switching to vi-mode to 0.1 sec
export PIPENV_VENV_IN_PROJECT=true # Configure Python 
export PSQLRC="${XDG_CONFIG_HOME}/pg/psqlrc"
export PSQL_HISTORY="${XDG_CONFIG_HOME}/pg/psql_history"
export TERM=xterm-256color # Encourage tmux and vim to display colors sanely

# History
export HISTFILE="${ZDOTDIR}/history"
export HISTSIZE=100000
export SAVEHIST=${HISTSIZE}
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
unsetopt SHARE_HISTORY           # Don't share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.


# Command prompt
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}"

function git_current_remote() {
  git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null
}

function _git_prompt_info() {
 ref=$(git symbolic-ref HEAD 2> /dev/null) || return
 echo "$(parse_git_dirty)[$(git_current_branch):$(git_current_remote)]"
}

_collapsed_wd() {
  echo $(pwd | perl -pe "s|^$HOME|~|g; s|/([^/]{1})[^/]*(?=/)|/\$1|g")
}

PROMPT='%{$fg[blue]%}$(_collapsed_wd) $(virtualenv_prompt_info)$(_git_prompt_info) %{$fg[white]%}%# %{$terminfo[white]%}'

# Aliases
alias be='bundle exec'
alias countdirs="find . -maxdepth 1 -type d -print0 | sort -z | xargs -0 -L1 du -hs"
alias df='df -h'
alias hl='highlight -O truecolor -s moria'
alias kc=kubectl
alias kcj='kubectl -o json'
alias kcy='kubectl -o yaml'
alias less='less -fSN'
alias ll='ls -lAGFh'
alias mrename="sed 's#\(.*\)#mv \"\1\" \"\1\"#' | sort | vim '+Tabularize/\"\zs \"/l0' -"
alias ping='prettyping --nolegend'
alias rust-lldb='PATH=/usr/bin:$PATH rust-lldb' # rust-lldb needs system python
alias vim=nvim

# Script to clear scrollback buffer
function cs() {
  /usr/bin/osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down' 2>1 /dev/null
  return 0
}

# Bindings
bindkey '^[[1;9D' backward-word
bindkey '^[[1;9C' forward-word
bindkey -r '\el' # Unbind "run command: ls"

eval `MANPATH= PATH= /usr/libexec/path_helper`
# # Integrations
## asdf
export ASDF_DATA_DIR=${XDG_CONFIG_HOME}/asdf
export ASDF_CONFIG_FILE=${ASDF_DATA_DIR}/asdfrc
[[ -f "$(brew --prefix)/opt/asdf/libexec/asdf.sh"  ]] && . "$(brew --prefix)/opt/asdf/libexec/asdf.sh"

## Use asdf to configure direnv hooks
[[ -f  "${XDG_CONFIG_HOME}/asdf-direnv/zshrc" ]] && source "${XDG_CONFIG_HOME}/asdf-direnv/zshrc"


# Integrations
## iTerm
test -e "${XDG_CONFIG_HOME}/.iterm2_shell_integration.zsh" && source "${XDG_CONFIG_HOME}/.iterm2_shell_integration.zsh"

## Direnv
eval "$(direnv hook zsh)"

## gcloud
source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"

## kubectl
# source /usr/local/var/homebrew/linked/kubernetes-cli/share/zsh/site-functions/_kubectl

test -e  "${XDG_CONFIG_HOME}/vmware/vmware.sh" && source "${XDG_CONFIG_HOME}/vmware/vmware.sh"

# NVM
export NVM_DIR="${XDG_CONFIG_HOME}/nvm"
[ -s "/usr/local/opt/nvm/nvm.sh"  ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# pyenv
eval "$(pyenv init -)"

# GVM
[[ -s "${HOME}/.gvm/scripts/gvm" ]] && source "${HOME}/.gvm/scripts/gvm"
#
# Java SDKs
export SDKMAN_DIR="${XDG_CONFIG_HOME}/.sdkman"
[[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"

# Paths
path=(
  ${HOME}/.rbenv/shims
  ${HOME}/.krew/bin
  ${HOME}/.cargo/bin
  /usr/local/sbin
  /usr/local/bin
  "$path[@]"
)
