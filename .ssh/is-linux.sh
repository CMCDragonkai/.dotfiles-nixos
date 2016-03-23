#!/usr/bin/env bash

kernel_name="$(uname --kernel-name)"
[ "${kernel_name#*Linux*}" != "$kernel_name" ] && exit 0 || exit 1