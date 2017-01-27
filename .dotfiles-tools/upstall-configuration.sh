#!/usr/bin/env bash

# default processing directory is this project root
processing_dir="$(dirname "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )")"

# process the command line parameters
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
      -d|--directory)
      processing_dir="$2"
      shift
      ;;
  esac
  shift # past argument or value
done

if ! source "$processing_dir/.dotfiles-config/profile_paths.conf"; then
    echo "$processing_dir is not a valid processing directory."
    exit 1
fi

if [[ "$(uname -s)" == Linux* ]]; then

    # The only Linux I use is NIXOS
    system='NIXOS'
    wintmp=''
    winsystmp=''

elif [[ $(uname -s) == CYGWIN* ]]; then

    system='CYGWIN'
    wintmp="$(cygpath --mixed "$(cmd /c 'ECHO %TMP%' | tr --delete '[:space:]')")"
    winsystmp="$(cygpath --mixed "$(cmd /c 'ECHO %SYSTEMROOT%' | tr --delete '[:space:]')\Temp")"

fi

pushd "$processing_dir"

    # Process the legally found M4 templates
    while read -r -d '' m4_filepath; do

        # Process to the filepath without the `.m4` extension
        # Note that `PH_` is our namespace meaning "PolyHack"
        m4 \
        --prefix-builtins \
        --include="${processing_dir}/.dotfiles-config/m4_includes" \
        --define=PH_SYSTEM="$system" \
        --define=PH_WINTMP="$wintmp" \
        --define=PH_WINSYSTMP="$winsystmp" \
        "$m4_filepath" > "${m4_filepath%.*}"

    done < <(find "$processing_dir" -type f -name '*.m4' -not -path "$processing_dir/.dotfiles-*" -print0)

    # It is VERY IMPORTANT for the subsequent commands to run inside `$processing_dir`

    # Generated and copied files during profile installation should start with a mask of 077 disallowing groups and other access
    umask 077

    # Copy the profiles over then run the final installations
    cp --target-directory="$HOME" --recursive --no-dereference --preserve=links --parents --force "${common_profile[@]}"

    if [ "$system" == 'NIXOS' ]; then

        cp --target-directory="$HOME" --recursive --no-dereference --preserve=links --parents --force "${nixos_profile[@]}"

    elif [ "$system" == 'CYGWIN' ]; then

        cp --target-directory="$HOME" --recursive --no-dereference --preserve=links --parents --force "${cygwin_profile[@]}"

    fi

popd

# Make sensitive directories and subdirectories 700, but their files 600
# This requires wiping out any execute permissions first
chmod --recursive a-x "$HOME/.ssh"
chmod --recursive u=rwX,g=,o= "$HOME/.ssh"
chmod --recursive a-x "$HOME/.gnupg"
chmod --recursive u=rwX,g=,o= "$HOME/.gnupg"
chmod --recursive a-x "$HOME/.aws"
chmod --recursive u=rwX,g=,o= "$HOME/.aws"

# Make the Public folder public
chmod --recursive a-x "$HOME/Public"
chmod --recursive u=rwX,g=r,o=r "$HOME/Public"
