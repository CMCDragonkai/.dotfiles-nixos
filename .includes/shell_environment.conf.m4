# Environment (for interactive and automated)

include(shell_environment_functions.conf.m4)

# language and locale settings
export LANG='en_US.UTF-8'
export LANGUAGE='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'

# these are to be replaced by the macros on deployment
export TZ="$TZ"
export TZDIR="$TZDIR"

# configuration variables for general commands
export BASH_ENV="${HOME}/.bash_env"
export TERM="${TERM:-xterm-256color}"
export PAGER='less --RAW-CONTROL-CHARS --LONG-PROMPT --HILITE-UNREAD --status-column --chop-long-lines --shift .3'
export EDITOR='vim'
export BROWSER='w3m'

# coloured man pages
export LESS_TERMCAP_mb=$(printf '\e[01;31m')       # enter blinking mode
export LESS_TERMCAP_md=$(printf '\e[01;38;5;75m')  # enter double-bright mode
export LESS_TERMCAP_me=$(printf '\e[0m')           # turn off all appearance modes (mb, md, so, us) 
export LESS_TERMCAP_se=$(printf '\e[0m')           # leave standout mode
export LESS_TERMCAP_so=$(printf '\e[01;33m')       # enter standout mode
export LESS_TERMCAP_ue=$(printf '\e[0m')           # leave underline mode
export LESS_TERMCAP_us=$(printf '\e[04;38;5;200m') # enter underline mode
export GROFF_NO_SGR=1

# private bin, man and info paths, for software that isn't managed by the package manager
export PATH="${HOME}/bin:${PATH}"
export MANPATH="${HOME}/man:${MANPATH}"
export INFOPATH="${HOME}/info:${INFOPATH}"

# default umask setting
umask 022

ifelse(PH_SYSTEM, CYGWIN,

    # Windows sets TMP, and we shall persist it as WINTMP
    # Then we set all other temporary environment variables to /tmp
    export WINTMP="$TMP"
    export TMPDIR='/tmp'
    export TMP='/tmp'
    export TEMP='/tmp'

    # setting windows code page to UTF8
    chcp 65001 >/dev/null

    # if we're not in an SSH session, then the Windows GUI is available
    if [ -z "$SSH_CLIENT" -a -z "$SSH_TTY" -a -z "$SSH_CONNECTION" ] -a ; then

        export BROWSER="$(import_exec firefox && echo "firefox" || { import_exec chrome && echo "chrome" || echo "$BROWSER"; })"

    fi

    # cygwin X
    if [ -n "$DISPLAY" ]; then
        
        # ...

    fi

,

    # TMPDIR is the canonical UNIX environment variable
    export TMPDIR="${TMPDIR:/tmp}"
    export TMP="${TMPDIR:/tmp}"
    export TEMP="${TMPDIR:/tmp}"

    # linux X
    if [ -n "$DISPLAY" ]; then

        import_exec emacs && export EDITOR="emacs" VISUAL="emacs"
        export BROWSER="$(import_exec firefox && echo "firefox" || { import_exec chromium && echo "chromium" || echo "$BROWSER"; })"
        export SUDO_ASKPASS="${HOME}/bin/dpass"

    fi

)