# Use KDE apps instead of GTK
export GTK_USE_PORTAL=1

# Manpagers
export MANPAGER="sh -c 'col -b | bat -l man -p'"
# export MANPAGER="nvim -c 'set ft=man' -"

export EDITOR="nvim"
export VISUAL="nvim"
export BROWSER="brave"
export TERMINAL="konsole"
export TERM="xterm-256color"
export WGETRC="${XDG_CONFIG_HOME:-$HOME/.config}/wget/wgetrc"

# XDG Paths
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

# Zsh config
export ZDOTDIR=$HOME/.config/zsh

# Default text editor for ssh connection
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='vim'
fi

# Default timeout for vi-mode
export KEYTIMEOUT=1

# Personal Scripts
export PATH="$HOME/bin:$PATH"
export PATH=$PATH:/home/$USER/.local/bin
