# .zshrc is sourced only on interactive sessions
# this script sets up interactive utilities

# The following lines were added by compinstall
zstyle :compinstall filename '/home/cmcdragonkai/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

HISTFILE=~/.zsh_history
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

# Functions

# Create NTFS (Windows) links, still usable by Cygwin
# Use this for creating links to files that have to be transparent to Windows applications
# Unix symlinks are not transparent to Windows applications
# mklink link target    - file symbolic link
# mklink /D link target - directory symbolic link
# mklink /H link target - hard link
# mklink /J link target - directory junction (you should prefer directory symbolic link instead)
mklink () {
    
    if [ "$#" -ge "3" ]; then
        cmd /c mklink "$1" "$2" "$3"
    else
        cmd /c mklink "$1" "$2"
    fi

}

# Aliases

alias cp="cp --interactive --verbose"
alias mv="mv --interactive --verbose"
alias ln="ln --interactive --verbose"
alias df="df --human-readable"
alias du="du --human-readable"
alias grep="grep --color=auto"
alias ls="ls --classify --color=auto --human-readable"
alias ll="ls --classify --color=auto --human-readable -l"
alias la="ls --classify --color=auto --human-readable -l --almost-all"
alias less="less --LONG-PROMPT --HILITE-UNREAD --status-column --chop-long-lines --shift .3"
alias ssh="ssh -F <(cat ~/.ssh/config ~/.ssh/hosts)"
alias scp="scp -F <(cat ~/.ssh/config ~/.ssh/hosts) -C"
alias sftp="sftp -F <(cat ~/.ssh/config ~/.ssh/hosts) -C"
alias sshf="ssh -F <(cat ~/.ssh/config ~/.ssh/hosts) -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

# Windows related things
# We need to run console.exe along with this to allow this work flawlessly in Cygwin mintty
alias powershell="powershell -NoLogo –ExecutionPolicy Bypass"