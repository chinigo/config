#!/bin/sh
set -o errexit
set -o nounset


# Git
[[ -e ~/.gitconfig ]] && mv -f ~/.gitconfig{,.bak}
ln -fhs "$(pwd)/gitconfig" ~/.gitconfig
[[ -e ~/.gitconfig.local ]] || touch ~/.gitconfig.local


# ZSH
[[ -e ~/.zshrc ]] && mv -f ~/.zshrc{,.bak}
ln -fhs "$(pwd)/zshrc" ~/.zshrc

[[ -e ~/.oh-my-zsh ]] && mv -f ~/.oh-my-zsh{,.bak}
ln -fhs "$(pwd)/oh-my-zsh/" ~/.oh-my-zsh


# Vim
[[ -e ~/.vim ]] && mv -f ~/.vim{,.bak}
ln -fhs "$(pwd)/vim-config/" ~/.vim

vim +PluginInstall +qa
