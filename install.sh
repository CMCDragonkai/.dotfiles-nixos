#!/usr/bin/env bash

# install the python packages via pip2 and pip3 
# this only occurs in Cygwin, not in Linux
# 
# compile the m4 scripts and everything..
# then install all the config files in the right places



# Merge Windows User Temporary with Cygwin /tmp
echo "none /tmp usertemp binary,posix=0 0 0" >> /etc/fstab
