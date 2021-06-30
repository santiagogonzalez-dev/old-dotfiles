autoload -Uz colors && colors
zstyle :compinstall filename '/home/st/.zshrc'
HISTFILE=~/.config/zsh/.zshHistory
HISTSIZE=60000
SAVEHIST=60000

setopt prompt_subst
setopt inc_append_history # Ensure that commands are added to the history immediately
setopt extended_history # Record the timestamp of each command in HISTFILE
setopt hist_find_no_dups # Skip duplicates while searching
setopt hist_save_no_dups # Do not write a duplicate event to the history file.
# unsetopt hist_save_no_dups # Write a duplicate event to the history file
# zmodload zsh/zprof # Uncomment to enable stats for Zsh with zprof command
setopt extendedglob nomatch menucomplete
unsetopt BEEP # No soud on error
setopt interactive_comments # Enable comments in interactive shell
setopt autocd # Automatically cd into typed directory.
stty stop undef # Disable ctrl-s to freeze terminal.

autoload -Uz compinit # Basic auto/tab complete:
zstyle ':completion:*' menu select
zmodload zsh/complist
_comp_options+=(globdots) # Include hidden files.
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
bindkey '^e' edit-command-line
autoload edit-command-line; zle -N edit-command-line

# Case Insensitive completition
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' \
  '+l:|?=** r:|?=**'

autoload -Uz vcs_info ## autoload vcs and colors

zstyle ':vcs_info:*' enable git # enable only git 

precmd_vcs_info() { vcs_info } # setup a hook that runs before every ptompt. 
precmd_functions+=( precmd_vcs_info )

zstyle ':vcs_info:git*+set-message:*' hooks git-untracked
# 
+vi-git-untracked(){
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
        git status --porcelain | grep '??' &> /dev/null ; then
        hook_com[staged]+='!' # signify new files with a bang
    fi
}

zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git:*' formats " %{$fg[blue]%}(%{$fg[red]%}%m%u%c%{$fg[yellow]%}%{$fg[magenta]%} %b%{$fg[blue]%})"

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

# Prompt
PROMPT="%B%{$fg[blue]%}[%{$fg[white]%}%n%{$fg[red]%}@%{$fg[white]%}%m%{$fg[blue]%}] %(?:%{$fg_bold[green]%} :%{$fg_bold[red]%} )%{$fg[cyan]%}%c%{$reset_color%} "
PROMPT+="\$vcs_info_msg_0_"
RPROMPT="Everglow"

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
# alias checkaur= 'for x in `pacman -Qm`; do paru -Ss "$x" | grep 'aur/'; done'
alias grep='grep --color'
alias df='df -h'
alias du='du -h'
alias e='exa -lah --icons --no-user'
alias et='exa -lah --icons --no-user -T -L3'
alias bat='bat --italic-text=always'
alias plasmarestart='kquitapp5 plasmashell && sleep 3 && kstart5 plasmashell

# Functions
function update() { 
	sudo pacman -Syu
	echo $?
	if [[ $? = 0 ]] then
		paru -Sua
	fi
}

cdl() { cd "$@" && ls -lAhX --group-directories-first --color=auto; }

# function cdet() {
#   cd "$@" && exa -lah --icons --no-user -T -L3;
# }
# 
# function cde() {
#   cd "$@" && exa -lah --icons --no-user;
# }

# function neo() {
#   command neovide "$@" & disown && sleep 1 ; exit
# }

# ex - archive extractor   #   usage: ex <file>
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

# Plugins
[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
source /usr/share/zsh/plugins/zsh-autopair/autopair.zsh 2>/dev/null
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh 2>/dev/null
source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
