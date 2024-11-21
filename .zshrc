export XDG_CONFIG_HOME=${HOME}/.config
export WORKSPACE_DIR=${HOME}/workspace

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
plugins=(gcloud iterm2 wd)

source ${ZSH}/oh-my-zsh.sh

##
# User configuration
##

# Environment variables

export EDITOR=nvim
export GIT_EDITOR=nvim
export KEYTIMEOUT=1 # Reduce delay switching to vi-mode to 0.1 sec
export PIPENV_VENV_IN_PROJECT=true # Configure Python 
export PSQLRC="${XDG_CONFIG_HOME}/pg/psqlrc"
export PSQL_HISTORY="${XDG_CONFIG_HOME}/pg/psql_history"
export TANZU_CLI_NO_INIT=true
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
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

function _git_current_remote() {
  git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null
}

function _git_prompt_info() {
 ref=$(git symbolic-ref HEAD 2> /dev/null) || return
 echo "$(parse_git_dirty)[$(git_current_branch):$(_git_current_remote)]"
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
alias ktx=kubectx
alias kns=kubens
alias less='less -fSN'
alias ll='ls -lAGFh'
alias mrename="sed 's#\(.*\)#mv \"\1\" \"\1\"#' | sort | vim '+Tabularize/\"\zs \"/l0' -"
alias ping='prettyping --nolegend'
alias rust-lldb='PATH=/usr/bin:$PATH rust-lldb' # rust-lldb needs system python
alias vim=nvim

# Script to clear scrollback buffer
function cs() {
  _iterm2_command "1337;ClearScrollback"
}

# Bindings
bindkey '^[[1;9D' backward-word
bindkey '^[[1;9C' forward-word
bindkey -r '\el' # Unbind "run command: ls"

# Paths
eval `MANPATH= PATH= /usr/libexec/path_helper`
path=(
  /opt/homebrew/sbin
  /opt/homebrew/bin
  ${HOME}/.krew/bin
  /usr/local/sbin
  "${WORKSPACE_DIR}/repos/github.com/chinigo/config/bin"
  "${WORKSPACE_DIR}/bin"
  "/Applications/IntelliJ IDEA 2024.1 EAP.app/Contents/MacOS"
  "$path[@]"
)


# # Integrations
## asdf
export ASDF_DATA_DIR=${XDG_CONFIG_HOME}/asdf
export ASDF_CONFIG_FILE=${ASDF_DATA_DIR}/asdfrc
[[ -f "$(brew --prefix)/opt/asdf/libexec/asdf.sh"  ]] && . "$(brew --prefix)/opt/asdf/libexec/asdf.sh"

## Use asdf to configure direnv hooks
eval "$("$(brew --prefix)"/bin/direnv hook zsh)"


## iTerm
[[ -e "${XDG_CONFIG_HOME}/zsh/.iterm2_shell_integration.zsh" ]] && source "${XDG_CONFIG_HOME}/zsh/.iterm2_shell_integration.zsh"

## kubectl
if command -v kubectl &>/dev/null && [[ ! -f "${ZSH_CACHE_DIR}/completions/_kubectl" ]]; then
  typeset -g -A _comps
  autoload -Uz _kubectl
  _comps[kubectl]=_kubectl

  kubectl completion zsh 2&>/dev/null > "${ZSH_CACHE_DIR}/completions/_kubectl"
fi

## kubectx & kubens
if command -v kubectx &>/dev/null && [[ ! -f "${ZSH_CACHE_DIR}/completions/_kubectx" ]]; then

  completion_file="$(brew --prefix kubectx 2>/dev/null)/share/zsh/site-functions/_kubectx"
  if [[ -f "${completion_file}" ]]; then
    typeset -g -A _comps
    autoload -Uz _kubectx
    _comps[kubectx]=_kubectx

    cp "${completion_file}" "${ZSH_CACHE_DIR}/completions/_kubectx"
  fi
fi

if command -v kubectx &>/dev/null && [[ ! -f "${ZSH_CACHE_DIR}/completions/_kubens" ]]; then

  completion_file="$(brew --prefix kubectx 2>/dev/null)/share/zsh/site-functions/_kubens"
  if [[ -f "${completion_file}" ]]; then
    typeset -g -A _comps
    autoload -Uz _kubens
    _comps[kubens]=_kubens

    cp "${completion_file}" "${ZSH_CACHE_DIR}/completions/_kubens"
  fi
fi


## IntelliJ
function idea() {
  "/Applications/IntelliJ IDEA.app/Contents/MacOS/idea" "${1}" &>/dev/null &!
}

