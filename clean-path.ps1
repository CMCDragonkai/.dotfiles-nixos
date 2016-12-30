#!/usr/bin/env powershell

# Since native installers can pollute the PATH, we need to reset the PATH declaratively
# The PATH can be polluted globally and locally

# setting the PATH....

# you may need to run this after each time you install a new application via Chocolatey or otherwise
# basically this is why it's not fully automated...

# actually this should a profile script
# however the script should also run at the very end of install.ps1 so as to clean the windows system PATH and user PATH