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
    notify \
    interactivecomments \
    hist_ignore_all_dups \
    hist_ignore_space

unsetopt beep
bindkey -v

#include "./.shell_functions"

# zsh functions

#include "./.shell_aliases"

# zsh aliases
