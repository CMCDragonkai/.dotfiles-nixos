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
        go get -u -v "${package_name}"
    else
        go get -v "${package_name}"
    fi
done <"$script_dir/../.dotfiles-config/go_packages.txt"
