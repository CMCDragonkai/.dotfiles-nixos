#!/usr/bin/env powershell

get-netadapter | get-netipaddress | select InterfaceAlias, IPAddress