# This .zshenv is sourced on all shell invocations
# This script only sets up environment variables and environmental functions
# It must not contain any output side effects

source "${HOME}/.includes_sh/shell_environment_common.conf"

# ZSH Environment

export SHELL="${SHELL:-zsh}"
