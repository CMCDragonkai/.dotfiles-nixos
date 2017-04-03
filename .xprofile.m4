m4_dnl Changing quoting/escaping characters to something that won't be used!
m4_changequote(`<<<@@||',`||@@>>>')

# This .xprofile is read by display managers during a graphical login.
# It is not read from `xinit`. So starting X from a text mode will not
# load .xprofile unless it is configured inside .xinitrc.
# Here we just setup environment variables.

m4_include(shell_environment.conf.m4)
