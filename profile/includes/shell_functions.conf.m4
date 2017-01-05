# Functions (for interactive only)

# Changing m4 quoting/escaping instead of backtick and apostrophe
changequote(<|,|>)

ifelse(PH_SYSTEM, CYGWIN,

    # Cygwin-only functions

    : '
    is-admin - Is the current session running with administrator privileges or not?
    
    Usage: is-admin
    
    Returns 0 or 1.
    '
    is-admin() {

        if net session > /dev/null 2>&1; then return 0
        else return 1; fi

    }
    
    : '
    win-users - List all users<|,|> groups and built-in accounts. Does not include service accounts.
    
    Usage: win-users
    '
    win-users() {
        powershell -Command 'Get-WmiObject -Class "win32_account" -Namespace "root\cimv2" | Sort-Object caption | Format-Table caption, __CLASS, FullName'
    }
    
    : '
    win-service-users - List all service account users
    
    Usage: win-service-users
    '
    win-service-users() {
        powershell -Command 'Get-Service | Foreach-Object {Write-Host NT Service\$($_.Name)}'
    }

,

    # Linux-only functions

)

# Common functions

: '
kill-jobs - Run kill on all jobs in a Bash or ZSH shell, allowing one to optionally pass in kill parameters.

Usage: kill-jobs [zsh-kill-options | bash-kill-options]

With no options, it sends `SIGTERM` to all jobs.
'
kill-jobs () {

    local kill_list
    kill_list="$(jobs)"
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
umask-calc - Calculate target permissions given octal umask and octal source permissions.

Usage: umask-calc "$(umask)" 777
'
umask-calc () {

    local mask
    local source
    
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
ssh-private-public - Convert an openssh private key to an openssh public key.

Usage: ssh-private-public <path-to-key> <path-to-key.pub>
'
ssh-private-public () {
    ssh-keygen -f "$1" -y >"$2"
}

: '
ssh-private-ppk - Convert an openssh private key to a putty ppk.

Usage: ssh-private-ppk <path-to-key> <path-to-key.ppk>
'
ssh-private-ppk () {
    puttygen "$1" -O private -o "$2"
}

: '
ssh-ppk-public - Convert a putty ppk to an openssh public key.

Usage: ssh-ppk-public <path-to-key.ppk> <path-to-key.pub>
'
ssh-ppk-public () {
    puttygen "$1" -O public-openssh -o "$2"
}

: '
ssh-ppk-private - Convert a putty ppk to an openssh private key.

Usage: ssh-ppk-private <path-to-key.ppk> <path-to-key>
'
ssh-ppk-private () {
    puttygen "$1" -O private-openssh -o "$2"
}

: '
date-ord - Convert from ordinal day of the year to another date format.

Usage: date-ord <year> <day-of-the-year> [date-flags]...
'
date-ord () { 

    year="$1"
    days="$2"
    shift
    shift
    date --date="$year-01-01 + $days days - 1 day" $@

}

: '
self-signed-cert - Create a self-signed SSL/TLS certificate for 100 years using RSA 2048.
                   If you do not pass in a day length, it will create a certificate of 100 years.

Usage: self-signed-cert <path-to-key.key> <path-to-cert.pem> [length-in-days]

Try to create one for localhost as your FQDN.
'
self-signed-cert () {
    if [ -n "$3" ]; then
        case "$3" in
            ''|*[!0-9]*) return 1 ;;
            *)           openssl req -x509 -nodes -days "$3" -newkey rsa:2048 -keyout "$1" -out "$2" ;;
        esac
    else
        openssl req -x509 -nodes -days 36500 -newkey rsa:2048 -keyout "$1" -out "$2"
    fi
}

: '
find-in-files - Find files based on string matching the contents.

Usage: find-in-files <path> <string> [-f | --filenames]

Options:
    -f --filenames    Show only file names instead of file names with matching content.
'
find-in-files () {

    if [ "$3" == "-f" ] || [ "$3" == '--filenames' ]; then
        find "$1" -type f -print0 | xargs -0 grep --files-with-matches "$2"
    else
        find "$1" -type f -print0 | xargs -0 grep "$2"
    fi
    
}

: '
process-starttime - Get start time of a process using its PID.
                    Time is returned as Unix time.
                    You can also just use `ps -o lstart= --pid ...`.

Usage: process-starttime <pid>
'
process-starttime () {

    uptime=($(cat "/proc/uptime"))
    process_statistics=($(cat "/proc/$1/stat")) || return 1
    clock_hertz="$(getconf CLK_TCK)"

    seconds_the_computer_is_up="${uptime[1]}"
    jiffies_the_process_is_up="${process_statistics[22]}"
    seconds_the_process_is_up="$(bc <<< "scale=3; $jiffies_the_process_is_up / $clock_hertz")"

    now_seconds="$(date +%s)"

    seconds_the_process_started=$((now_seconds - (seconds_the_computer_is_up - seconds_the_process_is_up)))
    
    printf "%s\n" "$seconds_the_process_started"

}
