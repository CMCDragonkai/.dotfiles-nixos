#!/usr/bin/env bash

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

script_path=$(dirname "$(readlink -f "$0")")

# Using python setuptools install both pip2 and pip3
for e in /usr/bin/easy_install-*; do
    eval "$e pip"
done

# Install Python packages on Cygwin
# Executables should be preferably Python 3

if $force; then

    pip2 install --upgrade --force-reinstall --requirement "$script_path/../.dotfiles-config/pip2_requirements.txt"
    pip3 install --upgrade --force-reinstall --requirement "$script_path/../.dotfiles-config/pip3_requirements.txt"

else

    pip2 install --requirement "$script_path/../.dotfiles-config/pip2_requirements.txt"
    pip3 install --requirement "$script_path/../.dotfiles-config/pip3_requirements.txt"

fi
