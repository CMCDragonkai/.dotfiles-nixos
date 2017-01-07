#!/usr/bin/env powershell
#requires -RunAsAdministrator
#requires -Version 5.0

# Enable Telnet
Get-WindowsOptionalFeature -Online -FeatureName TelnetClient | Enable-WindowsOptionalFeature -Online -All -NoRestart >$null

# Enable .NET Framework 3.5, 3.0 and 2.0
# This is required for some legacy applications and CUDA applications
Get-WindowsOptionalFeature -Online -FeatureName NetFx3 | Enable-WindowsOptionalFeature -Online -All -NoRestart >$null

# Enable Windows Containers
Get-WindowsOptionalFeature -Online -FeatureName Containers | Enable-WindowsOptionalFeature -Online -All -NoRestart >$null

# Enable Hyper-V hypervisor, this will prevent Virtualbox from running concurrently
# However Hyper-V can be disabled at boot for when you need to use virtualbox
# This is needed for Docker on Windows to run
Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V | Enable-WindowsOptionalFeature -Online -All -NoRestart >$null
