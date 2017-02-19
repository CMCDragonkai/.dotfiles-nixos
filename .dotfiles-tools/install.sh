#!/usr/bin/env bash

shopt -s extglob

# default parameters
force=false

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

# Fix the origin URL for this repository
origin='https://github.com/CMCDragonkai/.dotfiles.git'
origin_git='git@github.com:CMCDragonkai/.dotfiles.git'

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
        # HTTP cloning does not require authentication
        # However it does not allow push access
        # So we convert to using SSH instead of HTTP
        cd "$processing_dir" && git remote set-url origin "$origin_git"
        chmod u=rwx,g=,o= "$processing_dir"

    fi
popd

if [[ "$(uname -s)" == Linux* ]]; then

    :

elif [[ $(uname -s) == CYGWIN* ]]; then

    "$processing_dir"/.dotfiles-tools/set-timezone.sh

    # Merge Windows User Temporary with Cygwin /tmp
    cat <<'EOF' >/etc/fstab
# /etc/fstab

none /cygdrive cygdrive binary,posix=0,user 0 0
none /tmp usertemp binary,posix=0 0 0
EOF

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
    echo 'yes' | cygserver-config
    cygrunsrv --start='cygserver'

    # Enable cyglsa to allow user context switching without passing passwords
    # This will be important for cron and sshd... etc
    # However I cannot continue until I restart
    echo 'yes' | cyglsa-config

    # Enable cron as a service, running as Local System, using cyglsa, but don't start it running (start on reboot)
    # Run `crontab -e` to setup a cron job or `cronevents` to view the log (only available on cygwin)
    echo "yes\n\nno\nyes\nno" | cron-config

    # Enable dbus as a service
    # Edit /etc/dbus-1/system.conf
    echo "yes\nyes" | messagebus-config

    # Enable avahi as a service (relies on dbus) (integrates into Windows bonjour service)
    # Edit /etc/avahi/avahi-daemon.conf
    echo "yes\nyes" | avahi-daemon-config

    # Enable chere for right click context menu
    chere -i -t mintty -s zsh

    # Enabling CPAN for perl
    echo "\n\nno\nexit" | perl -MCPAN -e shell

    # Remember that cygrunsrv --list can be used to list all cygwin services

    # Compatibility tweaks...

    # Symlinking locale.h to xlocale.h (extended locale)
    # Note that xlocale.h is an Apple provided wrapper around locale.h
    # Cygwin obviously does not distribute such a header
    # Some libraries like numpy may expect xlocale.h, but we can just point them to the existing locale.h
    ln --symbolic --force /usr/include/locale.h /usr/include/xlocale.h

    # Patching npm to make it work in Cygwin (specifically Cygwin's git)
    # Patch derived from https://github.com/emigenix/npm_on_cygwin
    # This was created with `unix2dos` and `diff --unified`
    if patch --dry-run --force --silent "$PROGRAMFILES/nodejs/node_modules/npm/lib/utils/git.js" "$processing_dir/.dotfiles-data/npm-git.diff" >/dev/null 2>&1; then
        patch --backup "$PROGRAMFILES/nodejs/node_modules/npm/lib/utils/git.js" "$processing_dir/.dotfiles-data/npm-git.diff"
    fi

fi

# Process templates and copy the processed profile to `$HOME`
"$processing_dir"/.dotfiles-tools/upstall_configuration.sh

# Perform final package installations only after the profile has been copied or regenerated
if [[ "$(uname -s)" == Linux* ]]; then

    :

elif [[ $(uname -s) == CYGWIN* ]]; then

    # Install packages from source (they will be forced)
    "$processing_dir"/.dotfiles-tools/upstall-source-packages.sh

    if $force; then
        "$processing_dir"/.dotfiles-tools/upstall-python-packages.sh --force
    else
        "$processing_dir"/.dotfiles-tools/upstall-python-packages.sh
    fi

    if $force; then
        "$processing_dir"/.dotfiles-tools/upstall-node-packages.sh --force
    else
        "$processing_dir"/.dotfiles-tools/upstall-node-packages.sh
    fi

    if $force; then
        "$processing_dir"/.dotfiles-tools/upstall-go-packages.sh --force
    else
        "$processing_dir"/.dotfiles-tools/upstall-go-packages.sh
    fi

    # Assuming composer was installed by source installation scripts
    if hash composer 2>/dev/null; then
        composer global install --no-interaction
    fi

fi
