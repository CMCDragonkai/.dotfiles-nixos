m4_dnl Changing quoting/escaping characters to something that won't be used!
m4_changequote(`<<<@@||',`||@@>>>')

# This .pam_environment is sourced for session-wide logins.
# This means a textual or graphical login shell.
# This allows us to have environment variables setup after logging into our graphical display manager.
# This is provided by `pam_env.so`, which must be configured by the administrator to be sourced by any PAM enabled authentication agents.
# This is not a shell file as it is executed by PAM. It must follow the syntax defined in: http://www.linux-pam.org/Linux-PAM-html/sag-pam_env.html
# Note that this may not be read if configured, and also that HOME may not be available when this is read.
# This limits the usecase of this file to just absolute variables, and not relative variables.
