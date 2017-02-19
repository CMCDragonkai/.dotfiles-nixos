#!/usr/bin/env bash

force=false

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

script_path=$(dirname "$(readlink -f "$0")")

custom_user_agent="User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:32.0) Gecko/20100101 Firefox/32.0"

cleanup () {
    rm --recursive "$download_directory"
}

trap cleanup EXIT



download_directory="$(mktemp --tmpdir --directory 'python-wheels.XXX')"

cat "$script_path/../.dotfiles-config/windows_pip3_wheels.txt" \
| xargs \
    --max-args 1 \
    --max-procs=2 \
    wget \
    --directory-prefix="$download_directory" \
    --user-agent="$custom_user_agent"

exit

while read -r url || [[ -n "$url" ]]; do

    filename="${url##*/}"
    wpip3 install "${download_directory}/${filename}"

done <"$script_path/../.dotfiles-config/pip3_requirements.txt"

if $force; then

    wpip3 install --upgrade --force-reinstall --requirement "$script_path/../.dotfiles-config/pip3_requirements.txt"

else

    wpip3 install --requirement "$script_path/../.dotfiles-config/pip3_requirements.txt"

fi
