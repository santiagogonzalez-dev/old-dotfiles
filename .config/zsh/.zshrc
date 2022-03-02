# Compinit
_comp_options+=(globdots) # Include hidden files.
autoload -Uz compinit
for dump in $ZDOTDIR/.zcompdump(N.mh+12); do # Twice a day it's updated
    compinit
done
compinit -C # Basic auto/tab complete:

# Plugin manager

# Check if the file exists, and then source it using zsh-defer
function source_file {
    if [[ -e "$1" ]]; then
        source "$1"
    fi
}

# Zsh-defer
source "${ZDOTDIR}/plugins/zsh-defer/zsh-defer.plugin.zsh"

# Settings

# Zsh-completions
fpath=("${ZDOTDIR}/plugins/zsh-completions/src" $fpath)

autoload -Uz colors && colors

stty stop undef # Disable <C-s> to freeze terminal.

typeset -A __DOTS
__DOTS[ITALIC_ON]=$'\e[3m'
__DOTS[ITALIC_OFF]=$'\e[23m'

zstyle ':completion:*' completer _expand_alias _complete _ignored # Expand aliases with TAB
zstyle ':completion:*:git-checkout:*' sort false # disable sort when completing `git checkout`
zstyle ':completion:*:descriptions' format '[%d]' # set descriptions format to enable group support
zstyle ':completion:*' format %F{yellow}-- %B%U%{$__DOTS[ITALIC_ON]%}%d%{$__DOTS[ITALIC_OFF]%}%b%u --%f
zstyle ':compinstall:filename' '/home/st/.config/zsh/.zshrc'
zstyle ':completion:*:*:*:*:*' menu select=3 # If there's less than 3 items it will use normal tabs
zstyle ':completion:*:history-words' menu yes # Activate menu
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':autocomplete:*' min-delay 0.0  # Float
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|?=** r:|?=**'
zstyle -e ':completion:*' special-dirs '[[ $PREFIX = (../)#(..) ]] && reply=(..)'
zstyle ':completion:*' matcher-list '' '+m:{[:lower:]}={[:upper:]}' '+m:{[:upper:]}={[:lower:]}' '+m:{_-}={-_}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Automatically remove duplicates from these arrays
typeset -U path PATH cdpath CDPATH fpath FPATH manpath MANPATH

setopt multios
setopt aliases
setopt prompt_subst # Let the prompt substite variables, without this the prompt will not work
setopt brace_ccl # Allow brace character class list expansion
setopt complete_in_word # Complete from both ends of a word.
setopt always_to_end # Move cursor to the end of a completed word.
setopt correct # Turn on corrections
setopt extendedglob nomatch menucomplete
setopt interactive_comments # Enable comments in interactive shell
setopt hash_list_all # Whenever a command completion is attempted, make sure the entire command path is hashed first.
setopt rm_star_wait
unsetopt beep # Disable bell, no sound on error

# History
setopt inc_append_history # Ensure that commands are added to the history immediately
setopt hist_save_no_dups # Do not write a duplicate event to the history file.
setopt hist_expire_dups_first
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_verify
setopt autoparamslash
setopt share_history

HISTFILE=~/.config/zsh/.hist
HISTSIZE=1000000
SAVEHIST=1000000

# Directories
setopt auto_cd # Automatically cd into typed directory.
setopt auto_pushd # Push the current directory visited on the stack.
setopt pushd_ignore_dups # Do not store duplicates in the stack.
setopt pushd_silent # Do not print the directory stack after pushd or popd.

# Jobs
setopt auto_resume # Attempt to resume existing job before creating a new process.
setopt notify # Report status of background jobs immediately.
setopt no_hup # Don't kill jobs on shell exit.
unsetopt bg_nice # Don't run all background jobs at a lower priority.

# Modules
zmodload zsh/complist
zmodload zsh/deltochar
zmodload zsh/mathfunc
zmodload zsh/parameter

autoload zcalc
autoload zmv

# Vi mode
# Change cursor shape and prompt for different vi modes.
function cursor_shape {
    function zle-keymap-select {
        case $KEYMAP in
            vicmd) echo -ne '\e[1 q';; # Block, because vicmd implies it's in command mode
            viins|main) echo -ne '\e[5 q';; # Beam, because viins implies it's in insert mode
        esac
        vi_mode="${${KEYMAP/vicmd/${vi_cmd_mode}}/(main|viins)/${vi_ins_mode}}"
        zle reset-prompt
    }
    zle -N zle-keymap-select

    function zle-line-init {
        echo -ne "\e[5 q"
    }
    zle -N zle-line-init # Initial state of the shell when you open it. It's in insert mode, with the Beam cursor
    function preexec { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

    function TRAPINT {
        vi_mode=$vi_ins_mode
        return $(( 128 + $1 ))
    }

    vi_ins_mode=" "
    vi_cmd_mode="%{$fg[green]%} %{$reset_color%}"
    vi_mode=$vi_ins_mode
}
zle -N cursor_shape
autoload -Uz cursor_shape
cursor_shape

# Exit error code of the last command
function check_last_exit_code {
    local LAST_EXIT_CODE=$?
    if [[ $LAST_EXIT_CODE -ne 0 ]]; then
        local EXIT_CODE_PROMPT=' '
        EXIT_CODE_PROMPT+="%{$fg[red]%}❰%{$reset_color%}"
        EXIT_CODE_PROMPT+="%{$fg_bold[red]%}$LAST_EXIT_CODE%{$reset_color%}"
        EXIT_CODE_PROMPT+="%{$fg[red]%}❱%{$reset_color%}"
        echo "$EXIT_CODE_PROMPT"
    fi
}

# Git Status
function gitstatus {
    autoload -Uz vcs_info
    zstyle ':vcs_info:*' enable git svn

    # Setup a hook that runs before every ptompt.
    function precmd_vcs_info {
        vcs_info
    }
    precmd_functions+=(precmd_vcs_info)

    zstyle ':vcs_info:git*+set-message:*' hooks git-untracked

    function +vi-git-untracked {
        if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
            git status --porcelain | grep '??' &> /dev/null ; then
                hook_com[staged]+='!' # Signify new files with a bang
        fi
    }
    zstyle ':vcs_info:*' check-for-changes true
    zstyle ':vcs_info:git:*' formats " %{$fg[blue]%}❰%{$fg[red]%}%m%u%c%{$fg[yellow]%}%{$fg[magenta]%} %b%{$fg[blue]%}❱"
}

zsh-defer gitstatus

PS1="%n%F{white}@%f%{$reset_color%}%m%F{white} %3~%f%{$reset_color%}  %{$reset_color%}"
RPS1='$(check_last_exit_code) ${vi_mode} $vcs_info_msg_0_'

# Vi mode
bindkey -v

# Alias, functions and keymaps

alias .='echo $PWD'
alias cp='cp -HpRiv'
alias mv='mv -iv'
alias rm='rm -v'
alias l='ls -lAhX --group-directories-first --color=auto'
alias ls='ls -F --color=auto'
alias e='exa -lah --time-style=long-iso --icons --colour-scale --group-directories-first --git'
alias et='exa -lah --icons --colour-scale --group-directories-first --git -T -L4'
alias plasma-restart='kquitapp5 plasmashell && sleep 8 && kstart5 plasmashell && sleep 8 && kwin_wayland --replace &'
alias ip='ip --color=auto'
alias grep='grep --color'
# alias -g ...='../..'
# alias -g ....='../../..'
# alias -g .....='../../../..'
# alias -g CA="2>&1 | cat -A"
# alias -g C='| wc -l'
# alias -g D="DISPLAY=:0.0"
# alias -g DN=/dev/null
# alias -g ED="export DISPLAY=:0.0"
# alias -g EG='|& egrep'
# alias -g EH='|& head'
# alias -g EL='|& less'
# alias -g ELS='|& less -S'
# alias -g ETL='|& tail -20'
# alias -g ET='|& tail'
# alias -g F=' | fmt -'
# alias -g G='| egrep'
# alias -g H='| head'
# alias -g HL='|& head -20'
# alias -g Sk="*~(*.bz2|*.gz|*.tgz|*.zip|*.z)"
# alias -g LL="2>&1 | less"
# alias -g L="| less"
# alias -g LS='| less -S'
# alias -g MM='| most'
# alias -g M='| more'
# alias -g NE="2> /dev/null"
# alias -g NS='| sort -n'
# alias -g NUL="> /dev/null 2>&1"
# alias -g PIPE='|'
# alias -g R=' > /c/aaa/tee.txt '
# alias -g RNS='| sort -nr'
# alias -g S='| sort'
# alias -g TL='| tail -20'
# alias -g T='| tail'
# alias -g US='| sort -u'
# alias -g VM=/var/log/messages
# alias -g X0G='| xargs -0 egrep'
# alias -g X0='| xargs -0'
# alias -g XG='| xargs egrep'
# alias -g X='| xargs'
alias df='df -h -P --total --exclude-type=devtmpfs 2>/dev/null'
alias du='du -h'
alias free='free -m'
alias wget='wget --hsts-file="$XDG_CACHE_HOME/wget-hsts"'
alias -g sn='sudo -E nvim' # Open nvim with superuser privileges maintaining user configs
alias -g s='sudoedit'
alias n='nice -20 nvim'

# Goneovim
function g {
    nice -20 goneovim "$@" &; disown
}

# Fuzy search before launching Neovim
# requires: nvim, fzf, bat, exa
function no {
    nvim $(fzf --preview '([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (exa -1T -L 8 {} | less)) || echo {} 2> /dev/null | head -200')
}

# Fuzy search before launching Goneovim
# requires: goneovim, nvim, fzf, bat, exa
function gno {
    SELECTED=$(fzf --preview '([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (exa -1T -L 8 {} | less)) || echo {} 2> /dev/null | head -200')
    goneovim $SELECTED &; disown
}

# Package managers
alias pac='sudo pacman -Syu --noconfirm' # Update
alias pacinst='sudo pacman -S' # Install programs
alias pacparu='sudo pacman -Syyuu --noconfirm && paru' # Also update AUR packages
alias pacorphans='pacman -Qtdq' # Show orphans
alias pacremoveorphans='sudo pacman -Rns $(pacman -Qtdq)' # Remove orphan packages
# Git
alias -g ga='git add --all'
alias -g gco='git commit -v -m'
alias -g gclo='git clone --depth=1'
alias -g gd='git diff'
alias -g gi='gs; ga && gc -m "$(read -p '\''Commit message: '\''; echo $REPLY)" && gp && gs'
alias -g gl='git lg'
alias -g gm='gs; ga && gc -m "Minor update" && gp && gs'
alias -g gp='git push'
alias -g gpu='git pull'
alias -g gits='git status'
alias -g gcb='git checkout -b'
alias -g gnuke='git nukeall'

if [[ -f /bin/bat ]]; then
    themes=('1337' 'Coldark-Cold' 'Coldark-Dark' 'DarkNeon' 'Dracula' 'GitHub' 'Monokai Extended' 'Monokai Extended Bright' 'Monokai Extended Light' 'Monokai Extended Origin' 'Nord' 'OneHalfDark' 'OneHalfLight' 'Sublime Snazzy' 'TwoDark' 'Visual Studio Dark+' 'ansi' 'base16' 'base16-256' 'gruvbox-dark' 'gruvbox-light' 'zenburn')
    alias bat='bat --theme ${themes[RANDOM%${#themes[@]}]} --italic-text=always'
fi

function venv {
    NAME_ENV=$(basename $(pwd))
    python -m venv .venv --prompt $NAME_ENV
}

function myip {
    echo 'Your ip is:'
    curl ipinfo.io/ip
}

# Timeup the startup time of zsh
function timezsh {
    for i in $(seq 1 10); do time zsh -i -c exit; done
}

# Clear the screen and re-run the last command on your history
function last-command {
    clear
    zle up-history
    zle accept-line
}

zle -N last-command
bindkey '^[r' last-command # <A-r>

# Exit
function exit-proc {
    exit
    zle accept-line
}

zle -N exit-proc
bindkey '^[c' exit-proc # <A-c>

# Run the command on the background
function run {
    "$@" < /dev/null &> /dev/null &; disown
}

# Clone plugins repos
function clone_plugins {
    mkdir -p "${ZDOTDIR}/plugins"
    cd "${ZDOTDIR}/plugins"
    git clone --depth=1 git://github.com/zsh-users/zsh-completions.git
    git clone --depth=1 https://github.com/Aloxaf/fzf-tab
    git clone --depth=1 https://github.com/hlissner/zsh-autopair
    git clone --depth=1 https://github.com/romkatv/zsh-defer
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions
    git clone --depth=1 https://github.com/agkozak/zsh-z
    git clone --depth=1 https://github.com/zsh-users/zsh-history-substring-search
    git clone --depth=1 https://github.com/zdharma-continuum/fast-syntax-highlighting
}

# Extracting files
function ex {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)  tar xjf $1   ;;
            *.tar.gz)   tar xzf $1   ;;
            *.tar.xz)   tar xJf $1   ;;
            *.bz2)      bunzip2 $1   ;;
            *.rar)      unrar x $1   ;;
            *.gz)       gunzip $1    ;;
            *.tar)      tar xf $1    ;;
            *.tbz2)     tar xjf $1   ;;
            *.tgz)      tar xzf $1   ;;
            *.zip)      unzip $1     ;;
            *.Z)        uncompress $1;;
            *.7z)       7z x $1      ;;
            *)          echo "'$1' cannot be extracted via ex" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Enabling shift-tab for completion
bindkey -M menuselect '^[[Z' reverse-menu-complete

# Change title of the window to the working directory
function change_title {
    case $TERM in
        xterm*)
            function precmd {
                print -Pn - '\e]0;%~\a'
            }
            ;;
    esac
}

zsh-defer change_title

# Run the command but hold the contents on the prompt
bindkey -M viins '^\' accept-and-hold # Vi insert mode
bindkey -M vicmd '^\' accept-and-hold # Vi command mode

# Search with vim-like keybindings through autocompletion menu
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# Edit the command line with an external editor
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^[v' edit-command-line # Edit line with Alt+v in insert mode

# Search like in vim
bindkey -M vicmd '/' history-incremental-search-backward

# Zsh-autosuggestions
zsh-defer source "${ZDOTDIR}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
bindkey -M vicmd '^[a' autosuggest-accept
bindkey -M viins '^[a' autosuggest-execute

# Zsh-autopairs
zsh-defer source "${ZDOTDIR}/plugins/zsh-autopair/autopair.zsh"

# Fast-syntax-highlighting
zsh-defer source "${ZDOTDIR}/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"

# Zsh-history-substring-search
zsh-defer source "${ZDOTDIR}/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh"
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# Fzf-tab
zstyle ':fzf-tab:complete:nvim:*' fzf-preview 'bat --color=always --italic-text=always $realpath' # preview directory's content with exa when completing cd
zstyle ':fzf-tab:complete:cp:*' fzf-preview 'bat --color=always --italic-text=always $realpath' # preview directory's content with exa when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1a --colour-scale --icons --group-directories-first --color=always $realpath' # preview directory's content with exa when completing cd

function check_terminal_size {
    if [[ "$LINES $COLUMNS" != "$previous_lines $previous_columns" ]]; then
        set_default_opts
    fi
    previous_lines=$LINES
    previous_columns=$COLUMNS
}

function set_default_opts {
    HEIGHTVAR=$(($LINES/2))
    WIDTHVAR=$(($COLUMNS/2))
    zstyle ':fzf-tab:*' fzf-pad $HEIGHTVAR
    export FZF_DEFAULT_OPTS="
        --color=fg:#707a8c,bg:-1,hl:#3e9831,fg+:#cbccc6,bg+:#434c5e,hl+:#af87ff \
        --color=dark \
        --color=info:#ea9d34,prompt:#af87ff,pointer:#cb6283,marker:#cb6283,spinner:#ff87d7 \
        --sort \
        --preview-window=right:$WIDTHVAR \
        --bind '?:toggle-preview' \
        --border rounded"
}

set_default_opts && trap 'check_terminal_size' WINCH
zsh-defer source "${ZDOTDIR}/plugins/fzf-tab/fzf-tab.plugin.zsh"

# SDKMAN
zsh-defer source_file "${HOME}/.local/lib/sdkman/bin/sdkman-init.sh"
zsh-defer source_file "${NVM_DIR}/nvm.sh"

# Actions when changing of directory

function list_all {
    emulate -L zsh
    e
}

function enter_venv {
    if [[ -z "${VIRTUAL_ENV}" ]]; then
        if [[ -d ./.venv ]] ; then
            source ./.venv/bin/activate
        fi
    else
        parentdir="$(dirname "$VIRTUAL_ENV")"
        if [[ "$PWD"/ != "$parentdir"/* ]] ; then
            deactivate
        fi
    fi
}

# This array is run each time the directory is changed
chpwd_functions=(${chpwd_functions[@]} "list_all" "enter_venv")
