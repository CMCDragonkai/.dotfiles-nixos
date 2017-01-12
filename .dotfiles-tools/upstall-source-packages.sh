#!/usr/bin/env bash

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Install via the source installation scripts
# All of these are Makefiles with install and uninstall targets
for dir in "$script_dir"/../.dotfiles-config/source_installation_scripts/*/; do
    make --directory="$dir" install
done
