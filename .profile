# ~/.profile
# Single source of truth for *session-wide* environment.
# Must be POSIX-sh compatible and must not produce output.

# Guard against double-sourcing
[ -n "${__PROFILE_SOURCED-}" ] && return
export __PROFILE_SOURCED=1

# Home Manager session variables (generated)
if [ -r "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
  . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
fi

# Shared environment exports (keep this file pure: exports only, no output)
if [ -r "$HOME/.includes_sh/shell_environment_common.conf" ]; then
  . "$HOME/.includes_sh/shell_environment_common.conf"
fi