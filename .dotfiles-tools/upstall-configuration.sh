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
    localbin="$(dirname "${XDG_DATA_HOME:-$HOME/.local/share}")/bin"
    localbin_win="$localbin"
    localdata="${XDG_DATA_HOME:-$HOME/.local/share}"
    localdata_win="$localdata"
    localconfig="${XDG_CONFIG_HOME:-$HOME/.config}"
    localconfig_win="$localconfig"

elif [[ $(uname -s) == CYGWIN* ]]; then

    # if a configuration file uses the *_win version
    # this means they get a windows path using C:/...
    # however when the configuration file is used in Linux, it still get the same unix path
    # the *_win version is only needed for configuration files that prefer the windows path when available
    system='CYGWIN'
    wintmp="$(cygpath --mixed "$(cmd /c 'ECHO %TMP%' | tr --delete '[:space:]')")"
    winsystmp="$(cygpath --mixed "$(cmd /c 'ECHO %SYSTEMROOT%' | tr --delete '[:space:]')\Temp")"
    localbin="$HOME/.local/bin"
    localbin_win="$(cygpath --mixed "$localbin")"
    localdata="$HOME/.local/share"
    localdata_win="$(cygpath --mixed "$localdata")"
    localconfig="$HOME/.config"
    localconfig_win="$(cygpath --mixed "$localconfig")"

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
        --define=PH_LOCALBIN="$localbin" \
        --define=PH_LOCALBINWIN="$localbin_win" \
        --define=PH_LOCALDATA="$localdata" \
        --define=PH_LOCALDATAWIN="$localdata_win" \
        --define=PH_LOCALCONFIG="$localconfig" \
        --define=PH_LOCALCONFIGWIN="$localconfig_win" \
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

# Final tweaks to the $HOME

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

if [ "$system" == 'CYGWIN' ]; then

    # Convert ~/.emacs.d to a Windows symlink
    # On Cygwin, Emacs will be installed as a Windows Application
    emacs_submodule_path="$(readlink "$HOME/.emacs.d")"
    rm "$HOME/.emacs.d" && cmd /c mklink '/D' "$(cygpath --windows --absolute "$HOME/.emacs.d")" "$(cygpath --windows "$emacs_submodule_path")"

fi
