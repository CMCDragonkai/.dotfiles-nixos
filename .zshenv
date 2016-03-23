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

export LANG="en_US.UTF-8" LANGUAGE="en_US.UTF-8" LC_ALL="en_US.UTF-8"
export PAGER="less --RAW-CONTROL-CHARS --LONG-PROMPT --HILITE-UNREAD --status-column --chop-long-lines --shift .3"
export EDITOR="vim"
export BROWSER="curl"

# required for setting the Windows codepage to UTF8 
case "$(uname --kernel-name)" in
    *cygwin*|*CYGWIN*|*mingw*|*MINGW*|*msys*|*MSYS*)
        chcp 65001 >/dev/null
    ;;
esac

if [ -n "$DISPLAY" ]; then

    # environment variables set during X (GUI)

    import_exec emacs && export EDITOR="emacs" VISUAL="emacs"
    import_exec firefox && export BROWSER="firefox"

else 

    # environment variables set during just linux console or SSH

    import_exec w3m && export BROWSER="w3m"

fi