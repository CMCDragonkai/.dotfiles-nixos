source "$HOME/.includes_sh/shell_environment_common.conf"

# If TZ isn't set, then applications will assume `/etc/localtime`
# If TZDIR isn't set, then applications will assume `/usr/share/zoneinfo` or `/etc/zoneinfo` depending on the OS
# Since we manipulate the filesystem instead, these vairables do not need to be set.

m4_ifelse(PH_SYSTEM, CYGWIN,

    # Windows has a user local temporary and a system temporary
    export WINTMP="PH_WINTMP"
    export WINSYSTMP="PH_WINSYSTMP"
    source "$HOME/.includes_sh/shell_environment_cygwin.conf"

,)

m4_ifelse(PH_SYSTEM, NIXOS,

    source "$HOME/.includes_sh/shell_environment_nixos.conf"

,)
