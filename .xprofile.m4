m4_dnl Changing quoting/escaping characters to something that won't be used!
m4_changequote(`<<<@@||',`||@@>>>')

# This .xprofile is read by display managers during a graphical login.
# It is not read from `xinit`. So starting X from a text mode will not
# load .xprofile unless it is configured inside .xinitrc.
# Here we just setup environment variables.

m4_include(shell_environment.conf.m4)

# If your computer is intended to be portable,
# here is where you should write your (xrandr) multi-monitor configuration.
# If those monitors are not present, xrandr will silently fail.
# As in there will be no error codes.
# They shouldn't be committed to source control, as your user profile may be 
# used in many different monitor configurations.
# Example: xrandr --output DP-1 --right-of DP-0

# Set the wallpaper
feh --bg-fill ~/Pictures/wallpaper.png
