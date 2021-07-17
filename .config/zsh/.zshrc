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
zstyle ':vcs_info:git:*' formats "%{$fg[blue]%}(%{$fg[red]%}%m%u%c%{$fg[yellow]%}%{$fg[magenta]%} %b%{$fg[blue]%}) "

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
function check_last_exit_code() {
	local LAST_EXIT_CODE=$?
	if [[ $LAST_EXIT_CODE -ne 0 ]]; then
		local EXIT_CODE_PROMPT=' '
		EXIT_CODE_PROMPT+="%{$fg[red]%}-<%{$reset_color%}"
		EXIT_CODE_PROMPT+="%{$fg_bold[red]%}$LAST_EXIT_CODE%{$reset_color%}"
		EXIT_CODE_PROMPT+="%{$fg[red]%}>-%{$reset_color%}"
		echo "$EXIT_CODE_PROMPT"
	fi
}

PROMPT="%B%{$fg[blue]%}[%{$fg[white]%}%n%{$fg[red]%}@%{$fg[white]%}%m%{$fg[blue]%} %(?:%{$fg_bold[green]%} :%{$fg_bold[red]%} )%{$fg[cyan]%}%c%{$reset_color%} "
PROMPT+="\$vcs_info_msg_0_"
RPROMPT='$(check_last_exit_code)%{$fg[blue]%}]%'

# Load aliases and functions
source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.zshAliasFunrc"

# Plugins
[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
source /usr/share/zsh/plugins/zsh-autopair/autopair.zsh 2>/dev/null
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh 2>/dev/null
source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
