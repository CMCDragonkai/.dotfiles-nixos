#!/usr/bin/env powershell
#requires -RunAsAdministrator
#requires -Version 5.0

# DC means battery
# AC means plugged-in

# Require sign-in (lock screen) upon wakeup
# This is not the same as the `ScreenSaverIsSecure` setting, but it's more flexible
# Windows 10 allows specifying how long away you have to be before triggering the sign in
# I have not found a way to do this via powercfg or powershell or registry, you need to
# go to Sign-in options and select `Every Time` in the Require sign-in setting
powercfg -setdcvalueindex SCHEME_CURRENT SUB_NONE CONSOLELOCK 1
powercfg -setacvalueindex SCHEME_CURRENT SUB_NONE CONSOLELOCK 1

# Keep network on while sleeping (a.k.a. stand-by)
# This allows the computer to act like a phone when sleeping (persist wifi connection, check email... etc)
# Not all hardware supports this, but Surface Books should support it
# Switching this on requires the hardware to support both Modern Standby and Network Connected mode
# Use powercfg /A to see if your computer supports it
powercfg /setdcvalueindex SCHEME_CURRENT SUB_NONE CONNECTIVITYINSTANDBY 1
powercfg /setacvalueindex SCHEME_CURRENT SUB_NONE CONNECTIVITYINSTANDBY 1

# Lid close sleeps the computer
powercfg -setdcvalueindex SCHEME_CURRENT SUB_BUTTONS LIDACTION 1
powercfg -setacvalueindex SCHEME_CURRENT SUB_BUTTONS LIDACTION 1

# Power button hibernates the computer
powercfg -setdcvalueindex SCHEME_CURRENT SUB_BUTTONS PBUTTONACTION 2
powercfg -setacvalueindex SCHEME_CURRENT SUB_BUTTONS PBUTTONACTION 2

# Screen timing in seconds
# Turn off screen in 10 minutes on battery
# Turn off screen in 1 hr when plugged in
powercfg -setdcvalueindex SCHEME_CURRENT SUB_VIDEO VIDEOIDLE (10 * 60)
powercfg -setacvalueindex SCHEME_CURRENT SUB_VIDEO VIDEOIDLE (60 * 60)

# Allow programs to prevent the display turning off
powercfg -setdcvalueindex SCHEME_CURRENT SUB_VIDEO ALLOWDISPLAY 1
powercfg -setacvalueindex SCHEME_CURRENT SUB_VIDEO ALLOWDISPLAY 1

# Sleep timing in seconds
# After idle in 20 minutes on battery, go to sleep
# Never sleep when plugged in
powercfg -setdcvalueindex SCHEME_CURRENT SUB_SLEEP STANDBYIDLE (20 * 60)
powercfg -setacvalueindex SCHEME_CURRENT SUB_SLEEP STANDBYIDLE 0

# Hibernate timing in seconds
# After idle for 2 hrs on battery, go to hibernation
# Never hibernate when plugged in
powercfg -setdcvalueindex SCHEME_CURRENT SUB_SLEEP HIBERNATEIDLE (120 * 60)
powercfg -setacvalueindex SCHEME_CURRENT SUB_SLEEP HIBERNATEIDLE 0

# Allow away mode during sleep
# See: https://blogs.msdn.microsoft.com/david_fleischman/2005/10/21/what-does-away-mode-do-anyway/
powercfg -setdcvalueindex SCHEME_CURRENT SUB_SLEEP AWAYMODE 1
powercfg -setacvalueindex SCHEME_CURRENT SUB_SLEEP AWAYMODE 1

# Allow programs to prevent sleeping (stand-by and hibernation)
powercfg -setdcvalueindex SCHEME_CURRENT SUB_SLEEP SYSTEMREQUIRED 1
powercfg -setacvalueindex SCHEME_CURRENT SUB_SLEEP SYSTEMREQUIRED 1
