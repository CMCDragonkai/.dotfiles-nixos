m4_dnl Changing quoting/escaping characters to something that won't be used!
m4_changequote(`<<<@@||',`||@@>>>')

# This .bash_profile is sourced for login shells which can be interactive/non-interactive.
# If this is read, then ~/.bashrc will not automatically be read.
# This file will setup things related to initial logins.

# if it is interactive, load ~/.bashrc, which will subsequently load ~/.bash_env
# if it is not interactive, only load the ~/.bash_env
[[ $- == *i* ]] && source "${HOME}/.bashrc" || source "${HOME}/.bash_env"