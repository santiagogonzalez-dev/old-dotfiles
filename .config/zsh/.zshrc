# Compinit
_comp_options+=(globdots) # Include hidden files.
autoload -Uz compinit
for dump in $ZDOTDIR/refer/.zcompdump(N.mh+12); do # Twice a day it's updated
    compinit
done
compinit -C "${ZDOTDIR}/refer/.zcompdump" # Basic auto/tab complete:

# Zsh-defer
source "${ZDOTDIR}/refer/zsh-defer/zsh-defer.plugin.zsh"

# Settings
fpath=("${ZDOTDIR}/refer/zsh-completions/src" $fpath) # zsh-completions

autoload -Uz colors && colors

# Automatically remove duplicates from these arrays
typeset -U path PATH cdpath CDPATH fpath FPATH manpath MANPATH

setopt multios
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

HISTFILE=~/.config/zsh/refer/.hist
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
function cursor_shape () {
    function zle-keymap-select () {
        case $KEYMAP in
            vicmd) echo -ne '\e[1 q';; # Block, because vicmd implies it's in command mode
            viins|main) echo -ne '\e[5 q';; # Beam, because viins implies it's in insert mode
        esac
        vi_mode="${${KEYMAP/vicmd/${vi_cmd_mode}}/(main|viins)/${vi_ins_mode}}"
        zle reset-prompt
    }
    zle -N zle-keymap-select

    function zle-line-init() {
        echo -ne "\e[5 q"
    }
    zle -N zle-line-init # Initial state of the shell when you open it. It's in insert mode, with the Beam cursor
    preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

    function TRAPINT() {
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
function check_last_exit_code() {
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
function gitstatus() {
    autoload -Uz vcs_info
    zstyle ':vcs_info:*' enable git svn

    # Setup a hook that runs before every ptompt.
    precmd_vcs_info() {vcs_info}
    precmd_functions+=(precmd_vcs_info)

    zstyle ':vcs_info:git*+set-message:*' hooks git-untracked

    function +vi-git-untracked() {
        if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
            git status --porcelain | grep '??' &> /dev/null ; then
                hook_com[staged]+='!' # signify new files with a bang
        fi
    }
    zstyle ':vcs_info:*' check-for-changes true
    zstyle ':vcs_info:git:*' formats " %{$fg[blue]%}❰%{$fg[red]%}%m%u%c%{$fg[yellow]%}%{$fg[magenta]%} %b%{$fg[blue]%}❱"
}

zsh-defer gitstatus

PS1="%n%F{white}@%f%{$reset_color%}%m%F{white} %3~%f%{$reset_color%}  %{$reset_color%}"
RPS1='$(check_last_exit_code) ${vi_mode} $vcs_info_msg_0_'

zsh-defer source "${ZDOTDIR}/later.zsh"
