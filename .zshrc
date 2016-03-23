# .zshrc is sourced only on interactive sessions
# this script sets up interactive utilities

# The following lines were added by compinstall
zstyle :compinstall filename '/home/cmcdragonkai/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory autocd extendedglob nomatch notify interactivecomments
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install


# Aliases

alias cp="cp --interactive --verbose"
alias mv="mv --interactive --verbose"
alias df="df --human-readable"
alias du="du --human-readable"
alias grep="grep --color=auto"
alias ls="ls --classify --color=auto --human-readable"
alias ll="ls --classify --color=auto --human-readable -l"
alias la="ls --classify --color=auto --human-readable -l --almost-all"
alias less="less --LONG-PROMPT --HILITE-UNREAD --status-column --chop-long-lines --shift .3"