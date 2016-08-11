# This .bashrc is sourced only on interactive sessions.
# This script sets up interactive utilities.

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# Global options

# huponexit - makes sure child processes are sent SIGHUP when login interactive bash exits
# xpg_echo - align with ZSH behaviour
# lastpipe - align with ZSH behaviour
# no_empty_cmd_completion - align with ZSH behaviour
BASHOPTS=\
'autocd:\
cdspell:\
checkhash:\
checkjobs:\
checkwinsize:\
cmdhist:\
extglob:\
globstar:\
histappend:\
huponexit:\
interactive_comments:\
lastpipe:\
lithist:\
no_empty_cmd_completion:\
shift_verbose:\
xpg_echo'

HISTFILE="${HOME}/.bash_history"
HISTSIZE=10000
HISTFILESIZE=10000
HISTCONTROL='ignoreboth'
HISTTIMEFORMAT='%F %T '

# Bash Environment Variables

TTY="$(tty)"

# Bash Functions

include(shell_functions.conf)

$ '
repeat - Repeatedly run a command. Basically the same as ZSH \`repeat\`.

Usage: repeat <times> <command>
'
repeat () {

    times="$1"
    shift
    seq "$times" | xargs -I -- $*

}

# Bash Aliases

include(shell_aliases.conf)

# Bash Prompt

PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u ➜ \h  ➜ \[\e[33m\]\w\[\e[0m\]\n \$ '
PS2='$> ';
PS4='$0 - $LINENO $+ '