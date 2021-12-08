# XDG Paths
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state
export XDG_RUNTIME_DIR=/run/user/$UID
export XDG_DATA_DIRS=/usr/local/share:/usr/share
export XDG_CONFIG_DIRS=/etc/xdg

# KDE
# export GTK_USE_PORTAL=1
export KDEHOME=${XDG_CONFIG_HOME}/kde

# Manpagers
if which bat >/dev/null; then
	export MANPAGER="bash -c 'col -b | bat -l man -p'"
else
	export MANPAGER="nvim -c 'set ft=man' -"
fi
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

# Hardware acceleration
export LIBVA_DRIVER_NAME=iHD

# Personal Scripts
export PATH=$PATH:/home/$USER/.local/bin

# Rust
export RUSTUP_HOME=${XDG_DATA_HOME}/rustup

# z
export _Z_DATA=${ZDOTDIR}/.z

# fzf
export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden' # Faster than find command

# NVM
export NVM_DIR=${XDG_DATA_HOME}/nvm

# NPM
export NPM_CONFIG_USERCONFIG=${XDG_CONFIG_HOME}/npm/npmrc

# Firefox
export MOZ_ENABLE_WAYLAND=1
export MOZ_USE_XINPUT2=1
