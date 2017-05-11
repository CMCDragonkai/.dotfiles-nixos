m4_dnl Changing quoting/escaping characters to something that won't be used!
m4_changequote(`<<<@@||',`||@@>>>')

# This .bashenv is meant to be used inside BASH_ENV and sourced in ~/.bashrc.
# We attempt to simulate ZSH behaviour of ~/.zshenv
# This will be therefore be loaded on all Bash invocations.
# Therefore this should only be used to setup environment variables.

m4_include(shell_environment.conf.m4)

# Bash Environment

export SHELL="${SHELL:-bash}"
