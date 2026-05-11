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
