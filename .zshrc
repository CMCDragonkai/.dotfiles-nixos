# This .zshrc is sourced only on interactive sessions.
# This script sets up interactive utilities.

# Global options

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
DIRSTACKSIZE=20

setopt \
    appendhistory \
    autocd \
    autopushd \
    pushdsilent \
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
    prompt_subst \
    prompt_cr \
    prompt_sp

unsetopt beep

# Completions

zstyle :compinstall filename "${HOME}/.zshrc"
autoload -Uz compinit
compinit

# ZSH Environment Variables

export TTY="$(tty)"

HELPDIR="${HELPDIR:-/run/current-system/sw/share/zsh/${ZSH_VERSION}/help}"

# ZSH Functions

source "${HOME}/.includes_sh/shell_functions_common.conf"

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

: '
set-title - Set the shell title
'
set_title() {

    # tell the terminal we are setting the title
    print -n '\e]0;'
    # show hostname if connected through ssh
    [[ -n $SSH_CONNECTION ]] && print -Pn '(%m) '
    case $1 in
      expand-prompt)
        print -Pn $2;;
      ignore-escape)
        print -rn $2;;
    esac
    # end set title
    print -n '\a'

}

# ZSH Aliases

source "${HOME}/.includes_sh/shell_aliases_common.conf"

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
    rprompt+='%f%F{81}%y%f %F{110}%*%f'
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
    # Always update RPROMPT from the async file if it exists
    local f="$TMPDIR/zsh_rprompt_$$"
    if [[ -r $f ]]; then
        RPROMPT="$(<"$f")"
    fi
    ph_async_rprompt_pid=0

    # Only try to redraw the prompt when:
    # - this is an interactive shell, and
    # - ZLE is currently active (we're actually at a prompt)
    if [[ -o interactive && -n ${ZLE-} ]]; then
        zle reset-prompt
    fi
}


PROMPT='%F{150}»»%f '

if [[ -n $SSH_CONNECTION ]]; then
    PROMPT+='%F{100}%n%f ➜ %F{112}%m%f '
fi

PROMPT+='%F{100}%B${PWD/#$HOME/~}%b%f
 %F{180}%(!.%(?.♔.♚).%(?.♖.♜))%f '

RPROMPT=''

# ZSH Title

precmd_set_title () {

    set_title 'expand-prompt' '$SHELL: %~'

}

preexec_set_title () {

    set_title 'ignore-escape' "$2: ${PWD/#$HOME/~}"

}

# ZSH Hooks

# Hooking into pre-prompt commands
precmd_functions=($precmd_functions precmd_job_count precmd_rprompt precmd_set_title)

preexec_functions=($preexec_functions preexec_set_title)

chpwd_functions=($chpwd_functions chpwd_git_repo)

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
# Works on Cygwin and Kitty
# Also it does prevent reverse tabbing when autocomplete starts, but you can use arrow keys instead
bindkey -s '\e[Z' '^V^I'

# Alt + Y will copy the current command line prompt to X clipboard
if [ -n "$DISPLAY" ]; then
    copy_current_command_line() {
        echo -n $BUFFER | xclip -selection clipboard
    }
    zle -N copy_current_command_line
    bindkey '^[y' copy_current_command_line
fi

# Add Syntax Highlighting to ZSH
source "${HOME}/.dotfiles-modules/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
