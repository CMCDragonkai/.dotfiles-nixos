# This .zshenv is sourced on all shell invocations
# This script only sets up environment variables and environmental functions
# It must not contain any output side effects

m4_changequote(<|,|>)

m4_include(shell_environment.conf.m4)

# ZSH Environment

export SHELL="zsh"