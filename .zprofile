##
# ~/.zprofile (symlinked into $HOME and $ZDOTDIR)
##
# Sourced for every login zsh, interactive (iTerm, Terminal.app) or not
# (Cursor's agent-exec shell, ssh sessions, etc.). Runs AFTER /etc/zprofile's
# path_helper, so the prepends below land in front of the macOS system paths.
# That keeps asdf shims first regardless of which surface launched the shell.
#
# Cloud Agents (Linux, no Homebrew, no asdf, no Postgres 17) just silently
# skip the dirs they don't have — every prepend is guarded on existence.
##

# Defensive fallbacks. .zshenv always runs before .zprofile, but if something
# upstream nukes the env we still want sane defaults.
: ${XDG_CONFIG_HOME:="${HOME}/.config"}
: ${WORKSPACE_DIR:="${HOME}/workspace"}

# Homebrew — sets HOMEBREW_PREFIX, PATH, MANPATH, INFOPATH, etc.
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# asdf — paths only. Plugin shims are wired up via $ASDF_DATA_DIR/shims below;
# we deliberately don't `source asdf.sh` here since that's a no-op for shims-
# based asdf and would pull in interactive completions we don't need.
ASDF_CONF_DIR="${XDG_CONFIG_HOME}/asdf"
export ASDF_DATA_DIR="${ASDF_CONF_DIR}/data"
export ASDF_CONFIG_FILE="${ASDF_CONF_DIR}/asdfrc"

# De-dup PATH so re-sourcing (or Cursor's snapshot replay) can't introduce
# duplicates that distort ordering.
typeset -U path PATH

# Highest-priority entry first in the array. Walk in reverse so each iteration
# prepends in front of the previous result; final order matches the array.
local _prepend=(
  "${ASDF_DATA_DIR}/shims"
  "${HOMEBREW_PREFIX:+${HOMEBREW_PREFIX}/opt/postgresql@17/bin}"
  "${WORKSPACE_DIR}/repos/github.com/chinigo/config/bin"
  "${WORKSPACE_DIR}/bin"
)
local _i _dir
for (( _i = ${#_prepend[@]}; _i >= 1; _i-- )); do
  _dir="${_prepend[_i]}"
  [[ -n "$_dir" && -d "$_dir" ]] && path=("$_dir" "${path[@]}")
done
unset _prepend _i _dir

export _ZPROFILE_LOADED=1

export AWS_PROFILE=storyboard-dev
export AWS_REGION=us-east-2

export NODE_OPTIONS="--max-old-space-size=16384"
export STAGE=test
