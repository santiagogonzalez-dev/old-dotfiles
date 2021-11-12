#!/usr/bin/env bash

# TODO copy files using a for loop and a list

# This script would keep track of the files, based on their $HOME relative path

# Zsh
mkdir -p .config/zsh/
cp $ZDOTDIR/{.zshrc,.zlogin,.zshvi,.zshAliasFunrc} .config/zsh/
cp $HOME/.zshenv .

mkdir -p .local/share/
cp -r $HOME/.local/share/color-schemes .local/share

# Kitty
cp -r $XDG_CONFIG_HOME/kitty .config

# Desktop Entries
cp -r ~/.local/share/applications .local/share

# Scripts
cp -r $HOME/.local/bin .local
