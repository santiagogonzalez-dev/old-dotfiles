# Zsh config
export ZDOTDIR=$HOME/.config/zsh

# XDG Paths
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state
export XDG_RUNTIME_DIR=/run/user/$UID
export XDG_DATA_DIRS=/usr/local/share:/usr/share
export XDG_CONFIG_DIRS=/etc/xdg

# Change the xdg user directories
xdg-user-dirs-update --set DESKTOP "$HOME"/.local/Desktop
xdg-user-dirs-update --set DOWNLOAD "$HOME"/.local/Downloads
xdg-user-dirs-update --set TEMPLATES "$HOME"/.local/Templates
xdg-user-dirs-update --set PUBLICSHARE "$HOME"/.local/Public
xdg-user-dirs-update --set DOCUMENTS "$HOME"/.local/Documents
xdg-user-dirs-update --set MUSIC "$HOME"/.local/Music
xdg-user-dirs-update --set PICTURES "$HOME"/.local/Pictures
xdg-user-dirs-update --set VIDEOS "$HOME"/.local/Videos

# Hardware acceleration
export LIBVA_DRIVER_NAME=iHD

# KDE
# export GTK_USE_PORTAL=1
export KDEHOME=${XDG_CONFIG_HOME}/kde

# Firefox
export MOZ_ENABLE_WAYLAND=1
export MOZ_USE_XINPUT2=1

# Manpagers
if which bat >/dev/null; then
    export MANPAGER="bash -c 'col -b | bat -l man -p'"
else
    export MANPAGER="nvim -c 'set ft=man' -"
fi
export MANWIDTH=999

export LANG=en_US.UTF-8
export LC_COLLATE=C
export VISUAL="nvim"
export EDITOR="nvim"
export BROWSER="brave"
export TERMINAL="wezterm"
export TERM="xterm-256color"
export LESSHISTFILE="-"
export KEYTIMEOUT=1
export ZETTELPY_DIR="${HOME}/zettelpy"

# Directories
export CDPATH="${HOME}/workspace"

# Personal Scripts
# export PATH=$PATH:/home/$USER/.local/bin
export PATH=/home/$USER/.local/bin:$PATH

# Rustup
export RUSTUP_HOME=${XDG_DATA_HOME}/rustup
# Cargo
export CARGO_HOME=${XDG_DATA_HOME:-$HOME/.local/share}/cargo
export PATH=$PATH:${XDG_DATA_HOME}/cargo/bin

# Haskell
# cabal
export PATH="$HOME/.cabal/bin:$PATH"
# ghcup
export GHCUP_USE_XDG_DIRS="I hope haskell is worth it"

# z
export _Z_DATA=${ZDOTDIR}/.z

# fzf
export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden' # Faster than find command

# NVM
export NVM_DIR=${XDG_DATA_HOME}/nvm

# NPM
export NPM_CONFIG_USERCONFIG=${XDG_CONFIG_HOME}/npm/npmrc

# SDKMAN
export SDKMAN_DIR=${HOME}/.local/lib/sdkman
