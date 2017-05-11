m4_dnl Changing quoting/escaping characters to something that won't be used!
m4_changequote(`<<<@@||',`||@@>>>')

# This .zshenv is sourced on all shell invocations
# This script only sets up environment variables and environmental functions
# It must not contain any output side effects

m4_include(shell_environment.conf.m4)

# ZSH Environment

export SHELL="${SHELL:-zsh}"
