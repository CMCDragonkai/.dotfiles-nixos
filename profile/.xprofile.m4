# This .xprofile is read by display managers during a graphical login.
# It is not read from `xinit`. So starting X from a text mode will not 
# load .xprofile unless it is configured inside .xinitrc.
# Here we just setup environment variables.

include(shell_environment.conf.m4)