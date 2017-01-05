m4_dnl Changing quoting/escaping characters to something that won't be used!
m4_changequote(`<<<@@||',`||@@>>>')

# This .zshrc is sourced only on interactive sessions.
# This script sets up interactive utilities.

# Global options

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
    notify \
    prompt_subst

unsetopt beep

# Completions

zstyle :compinstall filename "${HOME}/.zshrc"
autoload -Uz compinit
compinit

# ZSH Environment Variables

export TTY="$(tty)"

m4_ifelse(PH_SYSTEM, NIXOS, 
    HELPDIR="${HELPDIR:-/run/current-system/sw/share/zsh/${ZSH_VERSION}/help}"
, PH_SYSTEM, CYGWIN, 
    HELPDIR="${HELPDIR:-/usr/share/zsh/${ZSH_VERSION}/help}"
)

# ZSH Functions

m4_include(shell_functions.conf.m4)

# ZSH Aliases

m4_include(shell_aliases.conf.m4)

# Sets up `help` command similar to bash.
unalias run-help 2>/dev/null
autoload run-help
alias help='run-help'

# ZSH Prompt

# Count the number of background jobs
precmd_job_count () {

    job_count=${(M)#${jobstates%%:*}:#running}r/${(M)#${jobstates%%:*}:#suspended}s
    if [[ $job_count == r0/s0 ]]; then 
        job_count=''
    else
        job_count=" [$job_count] "
    fi

}

# Hooking into pre-prompt commands
precmd_functions=($precmd_functions precmd_job_count)

PROMPT='%{$fg[green]%}%n%{$reset_color%} ➜ %{$fg[yellow]%}%m%{$reset_color%} ➜ %{$fg_bold[green]%}${PWD/#$HOME/~}%{$reset_color%} 
 ೱ ' 

RPROMPT='%{$fg[yellow]%}${job_count}%{$reset_color%}%{$fg[cyan]%}%D %*' 

# ZSH keys

# Enable Vi key bindings
bindkey -v

# Allows one to use Ctrl + Z to switch between foreground and background
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

# Add Syntax Highlighting to ZSH
source "${HOME}/modules/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"