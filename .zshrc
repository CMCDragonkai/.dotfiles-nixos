# .zshrc is sourced only on interactive sessions
# this script sets up interactive utilities

# The following lines were added by compinstall
zstyle :compinstall filename '/home/cmcdragonkai/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

HISTFILE='~/.zsh_history'
HISTSIZE=10000
SAVEHIST=10000

setopt \
    appendhistory \
    autocd \
    extendedglob \
    nomatch \
    interactivecomments \
    hist_ignore_all_dups \
    hist_ignore_space \
    auto_continue \
    check_jobs \
    hup \
    monitor \
    notify

# auto_continue
# check_jobs
# hup
# monitor 
# notify
# are all required to make sure jobs are killed when exited

unsetopt beep

bindkey -v

#include ".includes/shell_functions.conf"

## ZSH Functions
## ...

## ZSH Environment

TTY="$(tty)"

## NixOS should already define this
#ifdef NIXOS
HELPDIR="${HELPDIR:-/run/current-system/sw/share/zsh/${ZSH_VERSION}/help}"
#endif

#ifdef CYGWIN
HELPDIR="${HELPDIR:-/usr/share/zsh/${ZSH_VERSION}/help}"
#endif

#include ".includes/shell_aliases.conf"

# zsh environment

## Sets up `help` command similar to bash.
unalias run-help 2>/dev/null
autoload run-help
alias help='run-help'

# zsh prompt

PROMPT='%{$fg[green]%}%n%{$reset_color%} ➜ %{$fg[yellow]%}%m%{$reset_color%} ➜ %{$fg_bold[green]%}${PWD/#$HOME/~}%{$reset_color%} 
 ೱ ' 

RPROMPT='%{$fg[cyan]%}%D %*' 

# zsh keys

# Allows one to use Ctrl + Z to switch between foreground and background.
_ctrl-z () {
    if [[ $#BUFFER -eq 0 ]]; then
        BUFFER="fg"
        zle accept-line
    else
        zle push-input
        zle clear-screen
    fi
}
zle -N _ctrl-z
bindkey '^Z' _ctrl-z

# Shift + Tab will now always enter a literal tab
# Works on Cygwin and Konsole
# Also it does prevent reverse tabbing when autocomplete starts, but you can use arrow keys instead
bindkey -s '\e[Z' '^V^I'