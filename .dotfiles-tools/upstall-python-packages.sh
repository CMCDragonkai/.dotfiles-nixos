#!/usr/bin/env bash

script_path=$(dirname "$(readlink -f "$0")")

# Using python setuptools install both pip2 and pip3
for e in /usr/bin/easy_install-*; do
    eval "$e pip"
done

# Install Python packages on Cygwin
# Executables should be preferably Python 3
pip2 install --requirement "$script_path/../.dotfiles-config/pip2_requirements.txt"
pip3 install --requirement "$script_path/../.dotfiles-config/pip3_requirements.txt"
