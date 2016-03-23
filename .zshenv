# .zshenv is sourced on all shell invocations
# this script only sets up environment variables and environmental functions
# it must not contain any output side effects

import_exec () {
    for e in $@; do
        hash "$e" 2>/dev/null || { return 1; }
    done
    return 0
}

# fallbacks if nothing below gets set (minimum expectations)

export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

export TERM="${TERM:-xterm-256color}"
export PAGER="less --RAW-CONTROL-CHARS --LONG-PROMPT --HILITE-UNREAD --status-column --chop-long-lines --shift .3"
export EDITOR="$(import_exec vim && echo "vim" || echo "nano")"
export BROWSER="$(import_exec w3m && echo "w3m" || { import_exec curl && echo "curl" || echo "wget"; })"

export TMPDIR="/tmp"

# local bin for home made binary blobs
[ -d "${HOME}/bin" ] && export PATH="${HOME}/bin:${PATH}"

# required for setting the Windows codepage to UTF8 
case "$(uname --kernel-name)" in
    *cygwin*|*CYGWIN*|*mingw*|*MINGW*|*msys*|*MSYS*)
        chcp 65001 >/dev/null
    ;;
esac

# override some environment variables when running X (GUI)
if [ -n "$DISPLAY" ]; then

    import_exec emacs && export EDITOR="emacs" VISUAL="emacs"
    import_exec firefox && export BROWSER="firefox"

fi