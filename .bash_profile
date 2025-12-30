# ~/.bash_profile
# Login shell setup (TTY login, ssh login, etc).
# Goal: establish the session environment once, then load interactive config.

# Shared session environment (HM vars + your exports)
if [ -r "$HOME/.profile" ]; then
  source "$HOME/.profile"
fi

# If interactive, load interactive config.
case "$-" in
  *i*) [ -r "$HOME/.bashrc" ] && source "$HOME/.bashrc" ;;
esac