source "$HOME/.includes_sh/shell_environment_common.conf"

# timezone will be set during installation, and passed as M4 macro variables
export TZ="PH_TZ"
export TZDIR="PH_TZDIR"

m4_ifelse(PH_SYSTEM, CYGWIN,

    # Windows has a user local temporary and a system temporary
    export WINTMP=PH_WINTMP
    export WINSYSTMP=PH_WINSYSTMP
    source "$HOME/.includes_sh/shell_environment_cygwin.conf"

,)

m4_ifelse(PH_SYSTEM, NIXOS, 

    source "$HOME/.includes_sh/shell_environment_nixos.conf"

,)