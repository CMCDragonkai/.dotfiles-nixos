#!/usr/bin/env bash

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

script_dir=$(dirname "$(readlink -f "$0")")

while IFS=',' read package_name; do
    if $force; then
        stack exec -- ghc-pkg unregister --force "${package_name}"
    else
        stack install "${package_name}"
    fi
done <"$script_dir/../.dotfiles-config/stack_packages.txt"
