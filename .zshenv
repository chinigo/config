##
# ~/.zshenv (symlinked into $HOME and $ZDOTDIR)
##
# Sourced for every zsh invocation — interactive or not, login or not. Keep it
# small: foundational env only. PATH manipulation belongs in .zprofile so the
# prepends land AFTER /etc/zprofile's path_helper.
##

export XDG_CONFIG_HOME="${HOME}/.config"
export WORKSPACE_DIR="${HOME}/workspace"

# Keep the rest of the zsh dotfiles out of $HOME. Setting ZDOTDIR here (not in
# .zshrc) is what lets zsh find .zprofile and .zshrc at $ZDOTDIR/ on the very
# first invocation, so $HOME only needs the single .zshenv symlink.
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"

# asdf — paths only. Plugin shims are wired up via $ASDF_DATA_DIR/shims below;
# we deliberately don't `source asdf.sh` here since that's a no-op for shims-
# based asdf and would pull in interactive completions we don't need.
ASDF_CONF_DIR="${XDG_CONFIG_HOME}/asdf"
export ASDF_DATA_DIR="${ASDF_CONF_DIR}/data"
export ASDF_CONFIG_FILE="${ASDF_CONF_DIR}/asdfrc"


# Homebrew — sets HOMEBREW_PREFIX, PATH, MANPATH, INFOPATH, etc.
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

if [[ -f .zshenv.local ]]; then
  source .zshenv.local
fi


## Universal environment vars, shared with Claude
export AWS_PROFILE=storyboard-dev
export AWS_REGION=us-east-2

export NODE_OPTIONS="--max-old-space-size=16384"
export STAGE=test
