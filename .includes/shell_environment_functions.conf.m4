# Environment Functions (for interactive and automated)
# This is a standard library available to all shell scripts
# Portable between ZSH and Bash
# Included into `shell_environment.conf`

import_exec () {
    for e in $@; do
        hash "$e" 2>/dev/null || { return 1; }
    done
    return 0
}

import_user () {
    for i in $@; do
        [[ $(id -u -n) == "$i" ]] || { return 1; } 
    done
    return 0
}

import_fn () {
    for f in $@; do
        declare -f "$f" > /dev/null || { return 1; }
    done
    return 0
}