#!/usr/bin/env bash

# TODO copy files using a for loop and a list

# This script would keep track of the files, based on their $HOME relative path

# Zsh
cp $ZDOTDIR/{.zshrc,.zlogin,.zshvi,.zshAliasFunrc,zsh-defer,zsh-defer.plugin.zsh} .config/zsh/
cp $HOME/.zshenv .

# KDE Plasma
cp $XDG_CONFIG_HOME/{breezerc,kdeglobals,kglobalshortcutsrc,khotkeysrc,klipperrc,krunnerrc,kwinrc,plasma-org.kde.plasma.desktop-appletsrc,plasmanotifyrc} .config
cp $XDG_CONFIG_HOME/{okularpartrc,okularrc,powerdevilrc,powermanagementprofilesrc,startkderc} .config

# breezerc
# kdeglobals
# kglobalshortcutsrc
# khotkeysrc
# klipperrc
# krunnerrc
# kwinrc
# okularpartrc
# okularrc
# plasma-org.kde.plasma.desktop-appletsrc
# plasmanotifyrc
# powerdevilrc
# powermanagementprofilesrc
# startkderc

cp -r $HOME/.local/share/color-schemes .local/share

# Kitty
cp -r $XDG_CONFIG_HOME/kitty .config

# Scripts
cp -r $HOME/.local/bin .local
