#!/usr/bin/env bash

shopt -s extglob

# Fix the origin URL for this repository
origin='https://github.com/CMCDragonkai/.dotfiles.git'
# Processing directory is the directory that we perform the processing in
# It could be `$HOME` or a temporary directory
processing_dir=''

# Bash has dynamic scope, it will acquire the changed `$cloning_tmp_dir`
clean_up () {
    if [ -n "$cloning_tmp_dir" ]; then
        rm --recursive --force "$cloning_tmp_dir"
    fi
    exit $1
}

trap 'clean_up $?' INT TERM ERR

script_path=$(dirname "$(readlink -f "$0")")

# Installation might have started via a zipball download
# The zipballs will not contain all files that would in a legitimate repository
# For example `.git/` will be missing and any submodules will not be installed
# This means we must attempt a git clone if `$HOME` is not already the .dotfiles repository

# We need to be in $HOME to check if `$HOME` is a git repository
pushd "$HOME"

# If `$HOME` is already the .dotfiles git repository, then we just use that
if git_directory="$(git rev-parse --show-toplevel 2>&1)" \
&& [ "$git_directory" == "$HOME" ] \
&& git remote show -n origin | grep --quiet "Fetch URL: $origin";
then

    # Check if the `$HOME` has uncommitted changes or untracked files that are not ignored
    if ! git diff-index --quiet HEAD || ! { u="$(git ls-files --exclude-standard --others)" && test -z "$u"; }; then
        echo '$HOME is a git repository, but it currently has changes.'
        echo 'Stopping installation here, commit your changes and try again.'
        exit 1
    fi

    processing_dir="$HOME"

else

    # Clone the repository into an empty temporary directory
    cloning_tmp_dir="$(mktemp --directory -t '.dotfiles-cloning.XXX')"
    if ! git clone --recursive "$origin" "$cloning_tmp_dir"; then
        echo '$HOME is not a git repository, we attempted to clone, but this failed.'
        echo 'Stopping installation here, fix git or internet connection and try again.'
        exit 1
    fi

    processing_dir="$cloning_tmp_dir"

fi

# Dive into the processing directory
pushd "$processing_dir"

if [[ "$(uname -s)" == Linux* ]]; then

    # The only Linux I use is NIXOS
    system='NIXOS'

    wintmp=''
    winsystmp=''

    # On Linux, we assume timezone was already setup on OS installation
    tz="$(cat /etc/zoneinfo)"
    tzdir='/etc/zoneinfo'

elif [[ $(uname -s) == CYGWIN* ]]; then

    system='CYGWIN'

    wintmp="$(cmd /c 'ECHO %TMP%' | tr --delete '[:space:]')"
    winsystmp="$(cmd /c 'ECHO %SYSTEMROOT%' | tr --delete '[:space:]')\Temp"

    # Merge Windows User Temporary with Cygwin /tmp
    cat <<'EOF' >/etc/fstab
# /etc/fstab

none /cygdrive cygdrive binary,posix=0,user 0 0
none /tmp usertemp binary,posix=0 0 0
EOF

    # Acquire timezone information from Windows
    tz="$("$processing_dir/bin/tz-windows-to-iana" "$(tzutil /l | grep --before-context=1 "$(tzutil /g)" | head --lines=1)")"

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
    cat <<'EOF' >/etc/nsswitch.conf
# /etc/nsswitch.conf

passwd: files db
group: files db
db_enum: cache builtin
db_home: windows
db_shell: /bin/zsh
db_gecos: windows
EOF

    # Setting up Cygserver requires first deleting the cygserver.conf
    # The service will be setup
    rm --force /etc/cygserver.conf
    cygrunsrv --remove='cygserver' || true
    echo "yes" | cygserver-config
    cygrunsrv --start='cygserver'

    # Symlinking locale.h to xlocale.h (extended locale)
    # Note that xlocale.h is an Apple provided wrapper around locale.h
    # Cygwin obviously does not distribute such a header
    # Some libraries like numpy may expect xlocale.h, but we can just point them to the existing locale.h
    ln --symbolic --force /usr/include/locale.h /usr/include/xlocale.h

fi

# Now use m4 to process the templates
# We must not process templates that are ignored by our `.gitignore`
# Conversely this means we can use our `.gitignore` to know what directories and files are legal to scan

# Enable globbing for hidden files and folders
shopt -s dotglob
# Read all the legal paths into included_path
readarray -d '' -t included_paths_array < <(
    printf '%s\0' "$processing_dir"/* \
    | git check-ignore --stdin -z -v \
    | perl -e 'undef $/; $s = <>; while ($s =~ /\.gitignore\0\d+\0!.+?\0(.+?)\0/g) { print "$1\0"; }' \
    | while read -r -d '' included_path; do

        # We only care about files and directories
        # Directories need to have a globbing star added to it
        # `find` will use it for inclusion
        if [ -f "$included_path" ]; then
            printf '%s\0' "$included_path"
        elif [ -d "$included_path" ]; then
            included_path="$included_path/*"
            printf '%s\0' "$included_path"
        fi

    done
)
# Disable globbing for hidden files and folders
shopt -u dotglob

# Join the array with `-path` and `-or` in between
printf -v included_paths -- "-path '%s' -or " "${included_paths_array[@]}"
# Remove the last ` -or ` from the end of the string
included_paths="${included_paths::-5}"

# Interpolate the included paths
# The .dotfiles directories however should not be scanned (they are the configuration and metadata for my profile)
m4_scan_command="
find '${processing_dir}' \
-type f \
-name '*.m4' \
\( ${included_paths} \) \
-not -path '${processing_dir}/.dotfiles-*' \
-print0
"

# Process the legally found M4 templates
while read -r -d '' m4_filepath; do

    # Process to the filepath without the `.m4` extension
    # Note that `PH_` is our namespace meaning "PolyHack"
    m4 \
    --prefix-builtins \
    --include="${processing_dir}/.dotfiles-config/m4_includes" \
    --define=PH_SYSTEM="$system" \
    --define=PH_TZ="$tz" \
    --define=PH_TZDIR="$tzdir" \
    --define=PH_WINTMP="$wintmp" \
    --define=PH_WINSYSTMP="$winsystmp" \
    "$m4_filepath" > "${m4_filepath%.*}"

done < <(eval "$m4_scan_command")

# Make ~/.ssh directory and subdirectories 700, but the files 600
# This requires wiping out any execute permissions first
chmod --recursive a-x "$processing_dir/.ssh"
chmod --recursive u=rwX,g=,o= "$processing_dir/.ssh"

# Now we copy the built profile into $HOME but only if the processing directory isn't already `$HOME`
if [ "$processing_dir" != "$HOME" ]; then
    cp --archive "$processing_dir/." "$HOME/"
fi

# Pop the processing directory, return `$HOME`
popd

# Perform final package installations only after the profile has been copied or regenerated
if [[ "$(uname -s)" == Linux* ]]; then

    :

elif [[ $(uname -s) == CYGWIN* ]]; then

    # Install python packages
    "$processing_dir"/.dotfiles-tools/upstall-python-packages.sh

    # Install packages from source
    "$processing_dir"/.dotfiles-tools/upstall-source-packages.sh

fi

# Pop the home directory
popd

exit 0
