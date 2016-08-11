# Functions (for interactive only)

: '
killjobs - Run kill on all jobs in a Bash or ZSH shell, allowing one to optionally pass in kill parameters

Usage: killjobs [zsh-kill-options | bash-kill-options]

With no options, it sends `SIGTERM` to all jobs.
'
killjobs () {

    local kill_list="$(jobs)"
    if [ -n "$kill_list" ]; then
        # this runs the shell builtin kill, not unix kill, otherwise jobspecs cannot be killed
        # the `$@` list must not be quoted to allow one to pass any number parameters into the kill
        # the kill list must not be quoted to allow the shell builtin kill to recognise them as jobspec parameters
        kill $@ $(sed --regexp-extended --quiet 's/\[([[:digit:]]+)\].*/%\1/gp' <<< "$kill_list" | tr '\n' ' ')
    else
        return 0
    fi

}

: '
umask-calc - Calculate target permissions given octal umask and octal source permissions

Usage: umask-calc "$(umask)" 777
'
umask-calc () {

    mask="$1"
    source="$2"

    # must always provide the obase before the ibase
    # otherwise ibase changes the interpretation of subsequent numbers

    # convert mask and source to hex
    mask="$(bc <<< "obase=16;ibase=8; $mask")"
    source="$(bc <<< "obase=16;ibase=8; $source")"

    # perform bitwise logic
    target="$(bc <<< "obase=8;ibase=10; $((0x$source & ~0x$mask))")"

    echo "$target"

}

: '
ssh-private-ppk - Convert an openssh private key to a putty ppk

Usage: ssh-private-ppk <path-to-key> <path-to-key.ppk>
'
ssh-private-ppk () {
    puttygen "$1" -O private -o "$2"
}

: '
ssh-ppk-public - Convert a putty ppk to an openssh public key

Usage: ssh-ppk-public <path-to-key.ppk> <path-to-key.pub>
'
ssh-ppk-public () {
    puttygen "$1" -O public-openssh -o "$2"
}

: '
ssh-ppk-private - Convert a putty ppk to an openssh private key

Usage: ssh-ppk-private <path-to-key.ppk> <path-to-key>
'
ssh-ppk-private () {
    puttygen "$1" -O private-openssh -o "$2"
}

: '
date-ord - Convert from ordinal day of the year to another date format

Usage: date-ord <year> <day-of-the-year> [date-flags]...
'
date-ord () { 

    year="$1"
    days="$2"
    shift
    shift
    date --date="$year-01-01 + $days days - 1 day" $@

}
