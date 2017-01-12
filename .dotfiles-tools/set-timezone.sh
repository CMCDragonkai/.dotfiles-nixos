#!/usr/bin/env bash

# Only run this for Cygwin

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Acquire timezone information from Windows
# Set /etc/timezone
# Create a link from /etc/localtime to /usr/share/zoneinfo/$tz
# Create a link from /etc/zoneinfo to /usr/share/zoneinfo
# For immediate effect make sure TZ and TZDIR variables are unset!
tz="$("$script_dir/../bin/tz-windows-to-iana" "$(tzutil /l | grep --before-context=1 "$(tzutil /g)" | head --lines=1)")"

if [ -f /usr/share/zoneinfo/"$tz" ]; then
    echo "$tz" > /etc/timezone
    ln --symbolic --force /usr/share/zoneinfo/"$tz" /etc/localtime
    ln --symbolic --force /usr/share/zoneinfo /etc/zoneinfo
    printf "%s" "$tz"
    exit 0
else
    echo "Unable to acquire IANA timezone information, update the timezone matching script, or do it manually."
    exit 1
fi
