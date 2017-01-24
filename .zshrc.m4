m4_dnl Changing quoting/escaping characters to something that won't be used!
m4_changequote(`<<<@@||',`||@@>>>')

# This .zshrc is sourced only on interactive sessions.
# This script sets up interactive utilities.

# Global options

HISTFILE="$HOME/.zsh_history"
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

: '
eval-unpack - Evaluate an expression and unpack its STDOUT, STDERR and exit code
              into the passed variables.

Usage: eval-unpack <command> [stdout_variable] [stderr_variable] [exit_code_variable]
'
eval-unpack () {

    # normal eval returns just 0 when given no parameters
    if [[ "$#" -lt 1 ]]; then
        return 0
    fi

    local x y z
    local unpacked_stdout="${2:-x}"
    local unpacked_stderr="${3:-y}"
    local unpacked_exit="${4:-z}"

    unset "$unpacked_stdout" "$unpacked_stderr" "$unpacked_exit"
    eval "$(
        (eval "$1") \
        > >(eval "$unpacked_stdout=$(cat); typeset -p $unpacked_stdout") \
        2> >(eval "$unpacked_stderr=$(cat); typeset -p $unpacked_stderr"); \
        eval "$unpacked_exit=$?; \
        typeset -p $unpacked_exit"
    )"

}

# ZSH Aliases

m4_include(shell_aliases.conf.m4)

# Sets up `help` command similar to bash.
unalias run-help 2>/dev/null
autoload run-help
alias help='run-help'

# ZSH Prompt
# PROMPT is set synchronously
# RPROMPT is set asynchronously

# this must be run in the current shell context, and not in subshells
precmd_job_count () {

    ph_job_count=${(M)#${jobstates%%:*}:#running}r/${(M)#${jobstates%%:*}:#suspended}s
    if [[ $ph_job_count == '0r/0s' ]]; then
        ph_job_count=''
    else
        ph_job_count="[$ph_job_count]"
    fi

}

ph_is_in_git_repo=false
chpwd_git_repo() {
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        ph_is_in_git_repo=true
    else
        ph_is_in_git_repo=false
    fi
}

rprompt_git_status () {

    local ref branch git_status
    if $ph_is_in_git_repo; then
        ref=$(git symbolic-ref HEAD 2> /dev/null)
        branch="${ref#refs/heads/}"
        if test -z "$(command git status --porcelain --ignore-submodules -unormal 2>/dev/null)"; then
            git_status=''
        else
            git_status='⚡' # or try: Δ
        fi
        printf '%s' "$git_status($branch)"
        return 0
    else
        return 1
    fi

}

create_rprompt () {

    local git_status
    local rprompt='%F{104} '
    if [[ -n "$ph_job_count" ]]; then
        rprompt+="$ph_job_count "
    fi
    if git_status="$(rprompt_git_status)"; then
        rprompt+="$git_status "
    fi
    rprompt+='%f%F{110}%*%f'
    printf '%s' "$rprompt"

}

ph_async_rprompt_file="$TMPDIR/zsh_rprompt_$$"
ph_async_rprompt_pid=0
precmd_rprompt () {

    async () {
        printf '%s' "$(create_rprompt)" > "$ph_async_rprompt_file"
        kill -s USR1 $$
    }

    if [[ "${ph_async_rprompt_pid}" != 0 ]]; then
        kill -s HUP $ph_async_rprompt_pid >/dev/null 2>&1 || :
    fi

    async &!
    ph_async_rprompt_pid=$!

}

TRAPUSR1 () {
    RPROMPT="$(cat "$TMPDIR/zsh_rprompt_$$")"
    ph_async_rprompt_pid=0
    zle reset-prompt
}

# Hooking into pre-prompt commands
precmd_functions=($precmd_functions precmd_job_count precmd_rprompt)

chpwd_functions=($chpwd_functions chpwd_git_repo)

PROMPT='%F{100}%n%f ➜ %F{112}%m%f ➜ %F{100}%B${PWD/#$HOME/~}%b%f
 ೱ '

RPROMPT=''

zshexit () {
    rm --force "$ph_async_rprompt_file"
}

# ZSH keys

# Enable Vi key bindings
bindkey -v

# Show [NORMAL] status during vi command mode
function zle-line-init zle-keymap-select {
    old_rprompt="${RPROMPT}"
    vim_rprompt='%F{105}${${KEYMAP/vicmd/[% NORMAL]}/(main|viins)/}%f'
    RPROMPT="${vim_rprompt}${RPROMPT}"
    zle reset-prompt
    RPROMPT="${old_rprompt}"
}
zle -N zle-keymap-select

# Enable partial search (and jump to the end)
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end

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
source "${HOME}/.dotfiles-modules/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
