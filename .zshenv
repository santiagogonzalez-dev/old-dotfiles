# XDG Paths
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

# KDE
export GTK_USE_PORTAL=1
export KDEHOME="$XDG_CONFIG_HOME"/kde

# Manpagers
# export MANPAGER="sh -c 'col -b | bat -l man -p'"
export MANPAGER="nvim -c 'set ft=man' -"
export MANWIDTH=999

export VISUAL="nvim"
export EDITOR="nvim"
export BROWSER="brave"
export TERMINAL="kitty"
export TERM="xterm-256color"
export LESSHISTFILE="-"
export CARGO_HOME=${XDG_DATA_HOME:-$HOME/.local/share}/cargo
export KEYTIMEOUT=1

# Zsh config
export ZDOTDIR=$HOME/.config/zsh

# Personal Scripts
export PATH=$PATH:/home/$USER/.local/bin

# Rust
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup

# fzf
export FZF_DEFAULT_COMMAND='rg --files --hidden' # Faster than find command
