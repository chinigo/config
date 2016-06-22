#!/bin/sh

mv ~/.gitconfig ~/.gitconfig.bak
ln -s `pwd`/gitconfig ~/.gitconfig
touch ~/.gitconfig.local
