{
    # Compile zcompdump, if modified, to increase startup speed.
    zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
    if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
        zcompile "$zcompdump"
    fi
} &!

hash -d nvim="${XDG_CONFIG_HOME}/nvim/init.lua"
hash -d zsh="${ZDOTDIR}/.zshrc"
hash -d wezterm="${XDG_CONFIG_HOME}/wezterm/wezterm.lua"
