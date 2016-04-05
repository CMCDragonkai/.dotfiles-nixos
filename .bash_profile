# .bash_profile is sourced for login shells which can be interactive
# it should be mostly setting up shell wide environment variables

#include ".includes/shell_environment.conf"

# bash environment

export SHELL="bash"

source "${HOME}/.bashrc"
