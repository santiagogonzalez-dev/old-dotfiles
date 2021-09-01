#!/usr/bin/env bash

# This script would keep track of the files, based on their $HOME relative path

# Zsh
cp $ZDOTDIR/{.zshrc,.zlogin,.zshvi,.zshAliasFunrc} .config/zsh/
cp $HOME/.zshenv .

# KDE Plasma
cp $XDG_CONFIG_HOME/{breezerc,kdeglobals,kglobalshortcutsrc,klipperrc,krunnerrc,kwinrc,okularpartrc,okularrc,plasma-org.kde.plasma.desktop-appletsrc,plasmanotifyrc,powerdevilrc,powermanagementprofilesrc,startkderc} .config

# Kitty
cp -r $XDG_CONFIG_HOME/kitty .config

# Scripts
cp -r $HOME/.local/bin .local
