#!/usr/bin/env powershell
#requires -RunAsAdministrator
#requires -Version 5.0

# Power button hibernates the computer (Battery and Plugged In)
powercfg -setdcvalueindex SCHEME_CURRENT SUB_BUTTONS PBUTTONACTION 2
powercfg -setacvalueindex SCHEME_CURRENT SUB_BUTTONS PBUTTONACTION 2

# Lid close sleeps the computer (Battery and Plugged In)
powercfg -setdcvalueindex SCHEME_CURRENT SUB_BUTTONS LIDACTION 1
powercfg -setacvalueindex SCHEME_CURRENT SUB_BUTTONS LIDACTION 1

# Screen timing in seconds
# Turn off screen in 10 minutes on battery
# Turn off screen in 1 hr when plugged in
powercfg -setdcvalueindex SCHEME_CURRENT SUB_VIDEO VIDEOIDLE (10 * 60)
powercfg -setacvalueindex SCHEME_CURRENT SUB_VIDEO VIDEOIDLE (60 * 60)

# Sleep timing in seconds
# Sleep in 20 minutes on battery
# Never sleep when plugged in 
powercfg -setdcvalueindex SCHEME_CURRENT SUB_SLEEP STANDBYIDLE (20 * 60)
powercfg -setacvalueindex SCHEME_CURRENT SUB_SLEEP STANDBYIDLE 0

# Hibernate timing in seconds
# After sleeping for 2 hrs on battery, go to hibernation
# Never hibernate when plugged in
powercfg -setdcvalueindex SCHEME_CURRENT SUB_SLEEP HIBERNATEIDLE (120 * 60)
powercfg -setacvalueindex SCHEME_CURRENT SUB_SLEEP HIBERNATEIDLE 0