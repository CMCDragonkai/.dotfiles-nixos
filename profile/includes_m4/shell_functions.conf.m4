source "$HOME/.includes_sh/shell_functions_common.conf"

m4_ifelse(PH_SYSTEM, CYGWIN,

    source "$HOME/.includes_sh/shell_functions_cygwin.conf"

,)

m4_ifelse(PH_SYSTEM, NIXOS, 

    source "$HOME/.includes_sh/shell_functions_nixos.conf"

,)