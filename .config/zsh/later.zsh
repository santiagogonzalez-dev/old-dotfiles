bindkey -v

alias cp='cp -HpRiv'
alias mv='mv -iv'
alias rm='rm -v'
alias l='ls -lAhX --group-directories-first --color=auto'
alias ls='ls -F --color=auto'
alias e='exa -lah --time-style=long-iso --icons --colour-scale --group-directories-first --git'
alias et='exa -lah --icons --colour-scale --group-directories-first --git -T -L4'
alias bat='bat --italic-text=always'
alias plasma-restart='kquitapp5 plasmashell && sleep 1 && kstart5 plasmashell && sleep 1 && kwin_wayland --replace &'
alias ip='ip --color=auto'
alias grep='grep --color'
alias df='df -h -P --total --exclude-type=devtmpfs 2>/dev/null'
alias du='du -h'
alias free='free -m'
alias wget='wget --hsts-file="$XDG_CACHE_HOME/wget-hsts"'
alias sn='sudo -E nvim'
alias n='nice -20 nvim'

function timezsh {
    for i in $(seq 1 10); do time zsh -i -c exit; done
}

function no {
    nvim $(fzf --preview '([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (exa -1T -L 8 {} | less)) || echo {} 2> /dev/null | head -200')
}

# Clear the screen and re-run the last command on your history
function last-command {
    clear
    zle up-history
    zle accept-line
}
zle -N last-command
bindkey '^[r' last-command # Alt+r

# Exit
function exit-proc {
    exit
    zle accept-line
}
zle -N exit-proc
bindkey '^[c' exit-proc # Alt+c

function run() {
    "$@" < /dev/null &> /dev/null &; disown
}

# Extracting files
function ex() {
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
            *)          echo "'$1' cannot be extracted via ex()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Enabling shift-tab for completion
bindkey -M menuselect '^[[Z' reverse-menu-complete

# zsh-autosuggestions
source "${ZDOTDIR}/refer/zsh-autosuggestions/zsh-autosuggestions.zsh"
bindkey -M vicmd '^[a' autosuggest-accept && bindkey -M viins '^[a' autosuggest-execute

# zsh-autopairs
source "${ZDOTDIR}/refer/zsh-autopair/autopair.zsh"

# fast-syntax-highlighting
source "${ZDOTDIR}/refer/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"

# zsh-history-substring-search
source "${ZDOTDIR}/refer/zsh-history-substring-search/zsh-history-substring-search.zsh"
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# fzf-tab
zstyle ':completion:*:git-checkout:*' sort false # disable sort when completing `git checkout`
zstyle ':completion:*:descriptions' format '[%d]' # set descriptions format to enable group support
zstyle ':fzf-tab:complete:nvim:*' fzf-preview 'bat --color=always --italic-text=always $realpath' # preview directory's content with exa when completing cd
zstyle ':fzf-tab:complete:cp:*' fzf-preview 'bat --color=always --italic-text=always $realpath' # preview directory's content with exa when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1a --colour-scale --icons --group-directories-first --color=always $realpath' # preview directory's content with exa when completing cd
function check_terminal_size() {
    if [[ "$LINES $COLUMNS" != "$previous_lines $previous_columns" ]]; then
        set_default_opts
    fi
    previous_lines=$LINES
    previous_columns=$COLUMNS
}
function set_default_opts() {
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
source "${ZDOTDIR}/refer/fzf-tab/fzf-tab.plugin.zsh"

# Change title of the window to the working directory
function change_title() {
    case $TERM in
        xterm*)
            precmd() {print -Pn - '\e]0;%~\a'}
            ;;
    esac
} && change_title

# function chpwd() {
#     emulate -L zsh
#     e
# }
function list_all() {
    emulate -L zsh
    e
}
chpwd_functions=($(chpwd_functions[@]) "list_all")

# SDKMAN
source "${HOME}/.local/lib/sdkman/bin/sdkman-init.sh"

insert_doas() { zle beginning-of-line; zle -U "doas " }
replace_rm()  { zle beginning-of-line; zle delete-word; zle -U "rm " }

zle -N insert-doas insert_doas
zle -N replace-rm replace_rm

bindkey '^s'    insert-doas
bindkey '^r'    replace-rm
bindkey '^\'    accept-and-hold

# Search with vim-like keybindings through autocompletion menu
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^[v' edit-command-line # Edit line with Alt+v in insert mode
bindkey -M vicmd v edit-command-line # Edit line with v in command mode

# Search like in vi
bindkey -M vicmd '?' history-incremental-search-backward
bindkey -M vicmd '/' history-incremental-search-forward
