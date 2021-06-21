autoload -U colors && colors
zstyle :compinstall filename '/home/st/.zshrc'
HISTFILE=~/.zshHistory
HISTSIZE=60000
SAVEHIST=60000
setopt prompt_subst
setopt inc_append_history # Ensure that commands are added to the history immediately
setopt extended_history # Record the timestamp of each command in HISTFILE
setopt hist_find_no_dups # Skip duplicates while searching
setopt HIST_SAVE_NO_DUPS # Do not write a duplicate event to the history file.
#unsetopt HIST_SAVE_NO_DUPS # Write a duplicate event to the history file
unsetopt BEEP # No soud on error
setopt interactive_comments # Enable comments in interactive shell
setopt autocd # Automatically cd into typed directory.
[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh

# Basic auto/tab complete:
autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
# Rehash
zstyle ':completion:*' rehash true
# Include hidden files.
_comp_options+=(globdots)
compinit

# Binds and remaps
bindkey -v
bindkey '^ ' autosuggest-accept
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Case Insensitive completition
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' \
  '+l:|?=** r:|?=**'

# Change cursor shape for different vi modes.
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';; # block
        viins|main) echo -ne '\e[5 q';; # beam
    esac
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Aliases
alias snvim='sudo -E nvim'
alias zzz='systemctl suspend'
alias cd..='cd ..'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -v'
alias rd='rmdir'
alias l='ls -lAhX --group-directories-first --color=auto'
alias ls='ls -F --color=auto'
alias ip='ip --color=auto'
alias checkaur= 'for x in `pacman -Qm`; do paru -Ss "$x" | grep 'aur/'; done'
alias grep='grep --color'
alias df='df -h'
alias du='du -h'
alias e='exa -lah --icons --no-user'
alias et='exa -lah --icons --no-user -T -L3'
alias bat='bat --italic-text=always'
function update() { 
	sudo pacman -Syu
	echo $?
	if [[ $? = 0 ]] then
		paru -Sua
	fi
}
cdl() { cd "$@" && ls -lAhX --group-directories-first --color=auto; }
function cdet() {
  cd "$@" && exa -lah --icons --no-user -T -L3;
}
function cde() {
  cd "$@" && exa -lah --icons --no-user;
}
#function neo() {
#  command neovide "$@" & disown && sleep 1 ; exit
#}

# ex - archive extractor
# usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.tar.xz)    tar xJf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Plugins, from:
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
source /usr/share/zsh/plugins/zsh-autopair/autopair.zsh 2>/dev/null
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh 2>/dev/null
source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
