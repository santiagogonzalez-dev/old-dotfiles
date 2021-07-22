autoload -Uz colors && colors
zstyle :compinstall filename '/home/st/.config/zsh/.zshrc'
HISTFILE=~/.config/zsh/.zshHistory
HISTSIZE=60000
SAVEHIST=60000

zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))' # Ignore patterns

setopt prompt_subst # Let the prompt substite variables, without this the prompt will not work
setopt inc_append_history # Ensure that commands are added to the history immediately
setopt extended_history # Record the timestamp of each command in HISTFILE
setopt brace_ccl # Allow brace character class list expansion
setopt complete_in_word # Complete from both ends of a word.
setopt always_to_end # Move cursor to the end of a completed word.
setopt auto_resume # Attempt to resume existing job before creating a new process.
setopt notify # Report status of background jobs immediately.
setopt hist_find_no_dups # Skip duplicates while searching
setopt hist_save_no_dups # Do not write a duplicate event to the history file.
setopt correct # Turn on corrections
# unsetopt hist_save_no_dups # Write a duplicate event to the history file
# zmodload zsh/zprof # Uncomment to enable stats for Zsh with zprof command
setopt extendedglob nomatch menucomplete
unsetopt BEEP # No soud on error
unsetopt bg_nice # Don't run all background jobs at a lower priority.
unsetopt hup # Don't kill jobs on shell exit.
setopt interactive_comments # Enable comments in interactive shell
setopt autocd # Automatically cd into typed directory.
stty stop undef # Disable ctrl-s to freeze terminal.

autoload -Uz compinit # Basic auto/tab complete:
for dump in ~/.zcompdump(N.mh+12); do # Twice a day it's updated
    compinit
done
compinit -C

zstyle ':completion:*' menu select
zmodload zsh/complist
_comp_options+=(globdots) # Include hidden files.

# Binds and remaps
bindkey -v
bindkey '^ ' autosuggest-accept
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey '^e' edit-command-line # Edit line with ctrl-e
autoload edit-command-line; zle -N edit-command-line # Autoload this function ^

vim_ins_mode="%{$fg[cyan]%}[INS]%{$reset_color%}"
vim_cmd_mode="%{$fg[green]%}[CMD]%{$reset_color%}"
vim_mode=$vim_ins_mode

# Case Insensitive completition
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' \
  '+l:|?=** r:|?=**'

autoload -Uz vcs_info # Vcs and colors

zstyle ':vcs_info:*' enable git # Enable only git

precmd_vcs_info() { vcs_info } # Setup a hook that runs before every ptompt.
precmd_functions+=( precmd_vcs_info )

zstyle ':vcs_info:git*+set-message:*' hooks git-untracked

+vi-git-untracked(){
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
        git status --porcelain | grep '??' &> /dev/null ; then
        hook_com[staged]+='N!' # Signify new files with a upper case N and a bang
    fi
}

zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git:*' formats "%{$fg[blue]%}(%{$fg[red]%}%m%u%c%{$fg[yellow]%}%{$fg[magenta]%} %b%{$fg[blue]%}) "

# Change cursor shape for different vi modes.
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';; # Block, because vicmd implies it's in command mode
        viins|main) echo -ne '\e[5 q';; # Beam, because viins implies it's in insert mode
    esac
    vim_mode="${${KEYMAP/vicmd/${vim_cmd_mode}}/(main|viins)/${vim_ins_mode}}"
    zle reset-prompt
}
zle -N zle-keymap-select

zle-line-init() {
    echo -ne "\e[5 q"
}

# function zle-line-finish {
#     vim_mode=$vim_ins_mode
# }
#
# zle -N zle-line-finish
zle -N zle-line-init # Initial state of the shell when you open it. It's in insert mode, with the Beam cursor
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

function TRAPINT() {
    vim_mode=$vim_ins_mode
    return $(( 128 + $1 ))
}

# Exit code of the last command
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

# Random icon generator for the prompt
declare -a CHANGING # Changing prompt
CHANGING=(" " "∯ " " " " " " ")
declare -a FIRE # Changing prompt on error
FIRE=(" " " " " " " " " ")

RANDOM=$$$(date +%s) # Randomize based on date
ignition=${CHANGING[$RANDOM % ${#RANDOM[*]}+1]} # Defined the normal variable
fire=${FIRE[$RANDOM % ${#RANDOM[*]}+1]} # Defined the normal variable on error

PROMPT="%{$fg[white]%}%n%{$fg[red]%}@%{$fg[white]%}%m%{$fg[blue]%} %(?:%{$fg_bold[blue]%}$ignition :%{$fg_bold[red]%}$fire )%{$fg[cyan]%}%c%{$reset_color%} "
PROMPT+="\$vcs_info_msg_0_" # Git hook
# PROMPT="%{$fg[white]%}%n%{$fg[red]%}@%{$fg[white]%}%m%{$fg[blue]%} %(?:%{$fg_bold[green]%} :%{$fg_bold[red]%} )%{$fg[cyan]%}%c%{$reset_color%} "

RPROMPT='$(check_last_exit_code) ${vim_mode}'

# Load aliases and functions
source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.zshAliasFunrc"


# Plugins
source /usr/share/z/z.sh 2>/dev/null
export _Z_DATA="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.z"
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
source /usr/share/zsh/plugins/zsh-autopair/autopair.zsh 2>/dev/null
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh 2>/dev/null
source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
