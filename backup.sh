#!/usr/bin/env bash

# TODO copy files using a for loop and a list

# This script would keep track of the files, based on their $HOME relative path

# Zsh
mkdir -p .config/zsh/
cp $ZDOTDIR/{.zshrc,.zlogin,later.zsh} .config/zsh/
mkdir -p .config/zsh/refer
cp $ZDOTDIR/refer/clone_plugins.sh .config/zsh/refer/clone_plugins.sh
cp $HOME/.zshenv .

mkdir -p .local/share/
cp -r $HOME/.local/share/color-schemes .local/share

# Kitty
cp -r $XDG_CONFIG_HOME/kitty .config

# Wezterm
cp -r $XDG_CONFIG_HOME/wezterm .config

# Desktop Entries
cp -r ~/.local/share/applications .local/share

# Scripts
cp -r $HOME/.local/bin .local
