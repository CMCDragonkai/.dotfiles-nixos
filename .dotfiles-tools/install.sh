#!/usr/bin/env bash

shopt -s extglob

# process the command line parameters
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
      # Force for forcing reinstallation of packages
      -f|--force)
      force=true
      shift
      ;;
  esac
  shift # past argument or value
done

force="${force:-false}"

# Fix the origin URL for this repository
origin='https://github.com/CMCDragonkai/.dotfiles.git'

# Common profile paths
common_profile=(
    '.atom'
    '.aws'
    '.config'
    '.dotfiles-modules'
    '.gnupg'
    '.includes_sh'
    '.jupyter'
    '.local'
    '.ssh/keys'
    '.ssh/authorized_keys'
    '.ssh/config'
    '.ssh/identity.pub'
    '.Templates'
    '.vim'
    'bin'
    'Projects'
    'Public'
    '.bash_env'
    '.bash_profile'
    '.bashrc'
    '.curlrc'
    '.ghci'
    '.gitconfig'
    '.gitignore_global'
    '.inputrc'
    '.my.cnf'
    '.nanorc'
    '.netrc'
    '.sqliterc'
    '.vimrc'
    '.zlogin'
    '.zshenv'
    '.zshrc'
    'info'
    'man'
)

# Linux specific profile
linux_profile=(
    '.nixpkgs'
    '.xmonad'
    '.Xmodmap'
    '.Xresources'
    '.pam_environment'
    '.xprofile'
)

# Cygwin specific profile
cygwin_profile=(
    'AppData'
    'Documents'
    '.src'
    '.cmd_profile.bat'
    '.minttyrc'
)

# Installation might have started via a zipball download
# The zipballs will not contain all files that would in a legitimate repository
# For example `.git/` will be missing and any submodules will not be installed
# This means we must attempt a git clone

# If we are already in git repository, then we just use the current repository instead of cloning
repository_path="$(dirname "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )")"
pushd "$repository_path"
if git_directory="$(git rev-parse --show-toplevel 2>&1)" \
&& [ "$git_directory" == "$repository_path" ] \
&& { git remote show -n origin | grep --quiet "Fetch URL: $origin"; };
then

    if ! git diff-index --quiet HEAD || ! { u="$(git ls-files --exclude-standard --others)" && test -z "$u"; }; then
        echo "$repository_path is a git repository, but it currently has changes."
        echo 'Stopping installation here, commit your changes and try again.'
        sleep 5
        exit 1
    fi

    processing_dir="$repository_path"

else

    processing_dir="$HOME/.dotfiles"
    rm --recursive --force "$processing_dir"
    mkdir --parents "$processing_dir"
    if ! git clone --recursive "$origin" "$processing_dir"; then
        echo 'We attempted to clone to ~/.dotfiles, but this failed.'
        echo 'Stopping installation here, fix git or internet connection and try again.'
        sleep 5
        exit 1
    fi
    chmod u=rwx,g=r,o=r "$processing_dir"

fi
popd

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

done < <(find "$processing_dir" -type f -name '*.m4' -not -path "$processing_dir/.dotfiles-*" -print0)


# Make ~/.ssh directory and subdirectories 700, but the files 600
# This requires wiping out any execute permissions first
chmod --recursive a-x "$processing_dir/.ssh"
chmod --recursive u=rwX,g=,o= "$processing_dir/.ssh"
# Same for gnupg
chmod --recursive a-x "$processing_dir/.gnupg"
chmod --recursive u=rwX,g=,o= "$processing_dir/.gnupg"
# Same for .aws
chmod --recursive a-x "$processing_dir/.aws"
chmod --recursive u=rwX,g=,o= "$processing_dir/.aws"

# Copy the profiles over then run the final installations
# It is VERY IMPORTANT for the subsequent copy commands ot run inside `$processing_dir`
cp --target-directory="$HOME" --archive --parents --force "${common_profile[@]}"

# Perform final package installations only after the profile has been copied or regenerated
if [[ "$(uname -s)" == Linux* ]]; then

    cp --target-directory="$HOME" --archive --parents --force "${linux_profile[@]}"

elif [[ $(uname -s) == CYGWIN* ]]; then

    cp --target-directory="$HOME" --archive --parents --force "${cygwin_profile[@]}"

    # Install python packages
    if $force; then
        "$processing_dir"/.dotfiles-tools/upstall-python-packages.sh --force
    else
        "$processing_dir"/.dotfiles-tools/upstall-python-packages.sh
    fi

    # Install packages from source (no way to update them, they will always be forced)
    "$processing_dir"/.dotfiles-tools/upstall-source-packages.sh

fi

# Pop the processing directory
popd

exit 0
