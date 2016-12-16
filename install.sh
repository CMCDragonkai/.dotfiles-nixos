#!/usr/bin/env bash

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
    
    # Install Python packages on Cygwin
    # Executables should be preferably Python 3, and will be installed in ~/.local/bin
    pip2 --user --requirements "./pip2_requirements.txt"
    pip3 --user --requirements "./pip3_requirements.txt"
    
    # Install via the source installation scripts
    # All of these are Makefiles with install and uninstall targets
    for dir in ./source_installation_scripts/*/; do
        make --directory="$dir" install
    done
    
    # Setting up Cygserver requires first deleting the cygserver.conf
    # The service will be setup 
    rm --force /etc/cygserver.conf
    cygrunsrv --remove='cygserver' || true
    echo "yes" | cygserver-config
    cygrunsrv --start='cygserver'

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
