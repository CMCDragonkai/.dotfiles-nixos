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

# AUTOMATE the installation of windows_pip3_wheels
# Use AWS-CLI which is a pip3 package
# Endpoint is located here: https://matrix-python-windows.s3.amazonaws.com
# Use the rest endpoint or aws cp
# If using the rest endpoint, you should be able to do process substiution and acquire the object directly as a file descriptor, and pass that into pip3 install
# pip3 install <(aws s3 cp '...' -)
# something like that
# again environment variables must be passed...
# http://docs.aws.amazon.com/AmazonS3/latest/dev/S3_Authentication2.html
echo "$script_path/../.dotfiles-config/windows_pip3_wheels.txt"

if $force; then

    pip2 install --upgrade --force-reinstall --requirement "$script_path/../.dotfiles-config/pip2_requirements.txt"

    pip3 install --upgrade --force-reinstall --requirement "$script_path/../.dotfiles-config/pip3_requirements.txt"

    # now awscli is available
    # acquire install targets from awscli
    # we could expose an HTTP end point
    # but we need to secure it, unless u want randoms downloading from s3

    wpip3 install --upgrade --force-reinstall --requirement "$script_path/../.dotfiles-config/windows_pip3_requirements.txt"

else

    pip2 install --requirement "$script_path/../.dotfiles-config/pip2_requirements.txt"

    pip3 install --requirement "$script_path/../.dotfiles-config/pip3_requirements.txt"

    wpip3 install --requirement "$script_path/../.dotfiles-config/windows_pip3_requirements.txt"

fi
