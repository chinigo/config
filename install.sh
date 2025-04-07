#!/bin/sh
set -o errexit
set -o nounset

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

export XDG_CONFIG_HOME=${HOME}/.config
mkdir -p ${XDG_CONFIG_HOME}

# Submodule'd dependencies
echo "Cloning submodules..."
git -C ${SCRIPT_DIR} submodule update --init
echo "...done cloning submodules"


# ZSH

echo "Configuring ZSH..."

[[ -e "${HOME}/.zshrc" ]] && rm -f "${HOME}/.zshrc.bak" && mv -f "${HOME}/.zshrc" "${HOME}/.zshrc.bak"
ln -fhs "${SCRIPT_DIR}/.zshrc" "${HOME}/.zshrc"

echo "...done configuring ZSH"


# Oh My ZSH
echo "Installing Oh My ZSH!..."

OMZ_DIR="${XDG_CONFIG_HOME}/oh-my-zsh"
[[ -e "${OMZ_DIR}" ]] && rm -f "${OMZ_DIR}.bak" && mv -f "${OMZ_DIR}" "${OMZ_DIR}.bak"
ln -fhs "${SCRIPT_DIR}/oh-my-zsh/" "${OMZ_DIR}"

echo "...done installing Oh My ZSH!"


# Git
echo "Configuring git..."

GIT_CONF_DIR=${XDG_CONFIG_HOME}/git

[[ -e "${GIT_CONF_DIR}" ]] && rm -f "${GIT_CONF_DIR}.bak" $$ mv -f "${GIT_CONF_DIR}" "${GIT_CONF_DIR}.bak"
ln -fhs "${SCRIPT_DIR}/git" "${GIT_CONF_DIR}"

echo "...done configuring git"

# Homebrew
echo "Installing Homebrew..."

BREW_BINARY=/opt/homebrew/bin/brew
[[ -f "${BREW_BINARY}" ]] || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "...done installing Homebrew"


echo "Installing Homebrew packages..."

"${BREW_BINARY}" bundle --file "${SCRIPT_DIR}/Brewfile"

echo "...done installing Homebrew packages"

# Vim
echo "Configuring NeoVIM..."

VIM_CONF_DIR="${XDG_CONFIG_HOME}/nvim"
[[ -e "${VIM_CONF_DIR}" ]] && rm -f "${VIM_CONF_DIR}.bak" && mv -f "${VIM_CONF_DIR}" "${VIM_CONF_DIR}.bak"
ln -fhs "${SCRIPT_DIR}/vim-config/" "${VIM_CONF_DIR}"

nvim +PluginInstall +qa

echo "...done configuring NeoVIM"

# asdf
echo "Configuring asdf"
ln -fhs "${SCRIPT_DIR}/tool-versions" "${HOME}/.tool-versions"
echo "...done configuring asdf"


echo
echo "Done!"
