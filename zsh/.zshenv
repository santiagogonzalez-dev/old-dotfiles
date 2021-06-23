# archive selector
# with KDE-specific APIs
export GTK_USE_PORTAL=1

# "nvim" as manpager
export MANPAGER="nvim -c 'set ft=man' -"

# "bat" as manpager
export MANPAGER="sh -c 'col -b | bat -l man -p'"

# Configure VA-API
export LIBVA_DRIVER_NAME=iHD
# Configure VDPAU
export VDPAU_DRIVER=va_gl

# Ruby
#export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
#export PATH="$PATH:$GEM_HOME/bin"

export EDITOR="nvim"
export VISUAL="nvim"
export BROWSER="brave"
export TERMINAL="konsole"
export TERM="xterm-256color"

# Default text editor for ssh connection
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='vim'
fi

# Default timeout for vi-mode
export KEYTIMEOUT=1

export PATH=$PATH:/home/$USER/.local/bin
