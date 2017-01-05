source "$HOME/.includes_sh/shell_aliases_common.conf"

m4_ifelse(PH_SYSTEM, CYGWIN,

    source "$HOME/.includes_sh/shell_aliases_cygwin.conf"

,)

m4_ifelse(PH_SYSTEM, NIXOS, 

    source "$HOME/.includes_sh/shell_aliases_nixos.conf"

,)