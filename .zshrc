##
# ZSH configuration
##

export XDG_CONFIG_HOME="${HOME}/.config"
export WORKSPACE_DIR="${HOME}/workspace"

# Path to your oh-my-zsh configuration.
ZSH="${XDG_CONFIG_HOME}/oh-my-zsh"

ZSH_THEME="robbyrussell"
CASE_SENSITIVE="false"
COMPLETION_WAITING_DOTS="true"


##
# User configuration
##

# Terminal
export EDITOR=nvim
export KEYTIMEOUT=1 # Reduce delay switching to vi-mode to 0.1 sec
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
export TERM=xterm-256color # Encourage tmux and vim to display colors sanely

# History
export HISTFILE="${ZDOTDIR}/history"
export HISTSIZE=100000
export SAVEHIST="${HISTSIZE}"
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


##
# Aliases
##

alias countdirs="find . -maxdepth 1 -type d -print0 | sort -z | xargs -0 -L1 du -hs"
alias kc=kubectl
alias kcj='kubectl -o json'
alias kcy='kubectl -o yaml'
alias less='less -fSN'
alias ll='ls -lAGFh'
alias mrename="sed 's#\(.*\)#mv \"\1\" \"\1\"#' | sort | vim '+Tabularize/\"\zs \"/l0' -"
alias ping='prettyping --nolegend'
alias vim=nvim


##
# Bindings
##

bindkey '^[[1;9D' backward-word
bindkey '^[[1;9C' forward-word
bindkey -r '\el' # Unbind "run command: ls"


##
# Paths
##

eval "$(/opt/homebrew/bin/brew shellenv)"
path=(
  "${WORKSPACE_DIR}/repos/github.com/chinigo/config/bin"
  "${WORKSPACE_DIR}/bin"
  "${path[@]}"
)


##
# Integrations
##

# asdf
export ASDF_CONF_DIR="${XDG_CONFIG_HOME}/asdf"
export ASDF_DATA_DIR="${ASDF_CONF_DIR}/data"
export ASDF_CONFIG_FILE="${ASDF_CONF_DIR}/asdfrc"
export ASDF_DEFAULT_TOOL_VERSIONS_FILENAME="${ASDF_CONF_DIR}/tool-versions"
[[ -f "$(brew --prefix)/opt/asdf/libexec/asdf.sh"  ]] && . "$(brew --prefix)/opt/asdf/libexec/asdf.sh"

# direnv
eval "$("$(brew --prefix)"/bin/direnv hook zsh)"

# Git
export GIT_EDITOR="${EDITOR}"

# iTerm
[[ -e "${XDG_CONFIG_HOME}/zsh/.iterm2_shell_integration.zsh" ]] && source "${XDG_CONFIG_HOME}/zsh/.iterm2_shell_integration.zsh"

function cs() {
  _iterm2_command "1337;ClearScrollback"
}

# IntelliJ
function idea() {
  "/Applications/IntelliJ IDEA.app/Contents/MacOS/idea" "${1}" &>/dev/null &!
}

# Postgres
export PSQLRC="${XDG_CONFIG_HOME}/pg/psqlrc"
export PSQL_HISTORY="${XDG_CONFIG_HOME}/pg/psql_history"

# Pulumi (https://github.com/pulumi/pulumi)
export PULUMI_HOME="${XDG_CONFIG_HOME}/pulumi"

# wd (https://github.com/mfaerevaag/wd)
export WD_CONFIG="${XDG_CONFIG_HOME}/warprc"


##
# Initialize oh-my-zsh
##
plugins=(gcloud iterm2 wd)
source "${ZSH}/oh-my-zsh.sh"


##
# Command prompt
##
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}"

function _git_current_remote() {
  git rev-parse --abbrev-ref --symbolic-full-name "@{u}" 2>/dev/null
}

function _git_prompt_info() {
 ref=$(git symbolic-ref HEAD 2> /dev/null) || return
 echo "$(parse_git_dirty)[$(git_current_branch):$(_git_current_remote)]"
}

_collapsed_wd() {
  pwd | perl -pe "s|^$HOME|~|g; s|/([^/]{1})[^/]*(?=/)|/\$1|g"
}

PROMPT='%{$fg[blue]%}$(_collapsed_wd) $(virtualenv_prompt_info)$(_git_prompt_info) %{$fg[white]%}%# %{$terminfo[white]%}'

