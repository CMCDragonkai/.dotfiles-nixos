#!/usr/bin/env powershell

Get-NetAdapter | Get-NetIPAddress | Select InterfaceAlias, IPAddress | Sort InterfaceAlias