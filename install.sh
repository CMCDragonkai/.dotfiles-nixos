#!/usr/bin/env bash

# to be executed in after install.ps1
# or directly.. if in Linux

# install the python packages via pip2 and pip3 
# this only occurs in Cygwin, not in Linux
# 
# compile the m4 scripts and everything..
# then install all the config files in the right places

# This occurs after packages are alreeady installed via cygwin packages
# this needs to run the build...
# but before we run the build we must interrogate a few things
# and even run a few scripts

if [[ "$(uname -s)" == Linux* ]]; then

    # on Linux, we assume timezone was already setup on OS installation
    tz="$(cat /etc/zoneinfo)"
    tzdir="/etc/zoneinfo"

elif [[ $(uname -s) == CYGWIN* ]]; then

    # Merge Windows User Temporary with Cygwin /tmp
    echo "none /tmp usertemp binary,posix=0 0 0" >> /etc/fstab
    
    # Acquire timezone information from Windows
    tz="$(./bin/tz-windows-to-iana "$(tzutil /l | grep --before-context=1 "$(tzutil /g)" | head --lines=1)")"
    
    if [ -f /usr/share/zoneinfo/"$tz" ]; then
        echo "$tz" > /etc/timezone
        ln --symbolic --force /usr/share/zoneinfo/"$tz" /etc/localtime
        ln --symbolic --force /usr/share/zoneinfo /etc/zoneinfo
        tzdir="/usr/share/zoneinfo"
    else 
        echo "Unable to acquire IANA timezone information, update the timezone matching script, or do it manually."
    fi
    
    # Change default shell to zsh
    # On Linux we could use chsh --shell
    # But Cygwin doesn't support it, so we just need to edit it using sed
    sed --in-place "/^${USER}/ s/:[^:][^:]*$/:"${$(which zsh)//\//\\\/}"/" /etc/passwd

fi

# We need to pass "PH_TZ" and "PH_TZDIR" as variables to m4 preprocessor

# run the m4 macro and build into ./.build folder

# copy files from ./.build into ~
# where --archive means: --recursive --links --perms --times --group --owner
rsync --update --checksum --archive "./.build/" "${HOME}/"

# Make ~/.ssh directory and subdirectories 700, but the files 600
# This requires wiping out any execute permissions first
chmod --recursive a-x ~/.ssh
chmod --recursive u=rwX,g=,o= ~/.ssh
