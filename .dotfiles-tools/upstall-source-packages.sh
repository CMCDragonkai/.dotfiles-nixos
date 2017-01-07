#!/usr/bin/env bash

script_path=$(dirname "$(readlink -f "$0")")

# Install via the source installation scripts
# All of these are Makefiles with install and uninstall targets
for dir in "$script_path"/../.dotfiles-config/source_installation_scripts/*/; do
    make --directory="$dir" install
done
