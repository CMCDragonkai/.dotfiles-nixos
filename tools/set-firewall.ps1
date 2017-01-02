#!/usr/bin/env powershell
#requires -RunAsAdministrator
#requires -Version 5.0

param (
    [string]$InstallationDirectory = "$Env:UserProfile", 
)

# Setup firewall to accept pings for Domain and Private networks but not from Public networks
Set-NetFirewallRule `
    -DisplayName "File and Printer Sharing (Echo Request - ICMPv4-In)" `
    -Enabled True `
    -Action "Allow" `
    -Profile "Domain,Private"`
    >$null
Set-NetFirewallRule `
    -DisplayName "File and Printer Sharing (Echo Request - ICMPv6-In)" `
    -Enabled True `
    -Action "Allow" `
    -Profile "Domain,Private"`
    >$null

# Setup firewall to accept connections from 55555 in Domain and Private networks
Remove-NetFirewallRule -DisplayName "Polyhack - Private Development Port (TCP-In)" -ErrorAction SilentlyContinue
Remove-NetFirewallRule -DisplayName "Polyhack - Private Development Port (UDP-In)" -ErrorAction SilentlyContinue
New-NetFirewallRule `
    -DisplayName "Polyhack - Private Development Port (TCP-In)" `
    -Direction Inbound `
    -EdgeTraversalPolicy Allow `
    -Protocol TCP `
    -LocalPort 55555 `
    -Action Allow `
    -Profile "Domain,Private" `
    -Enabled True `
    >$null
New-NetFirewallRule `
    -DisplayName "Polyhack - Private Development Port (UDP-In)" `
    -Direction Inbound `
    -EdgeTraversalPolicy Allow `
    -Protocol UDP `
    -LocalPort 55555 `
    -Action Allow `
    -Profile "Domain,Private" `
    -Enabled True `
    >$null

# Port 22 for Cygwin SSH
Remove-NetFirewallRule -DisplayName "Polyhack - SSH (TCP-In)" -ErrorAction SilentlyContinue
New-NetFirewallRule `
    -DisplayName "Polyhack - SSH (TCP-In)" `
    -Direction Inbound `
    -EdgeTraversalPolicy Allow `
    -Protocol TCP `
    -LocalPort 22 `
    -Action Allow `
    -Profile "Domain,Private" `
    -Program "${InstallationDirectory}\cygwin64\usr\sbin\sshd.exe" `
    -Enabled True `
    >$null

# Port 80 for HTTP, but blocked by default (switch it on when you need to)
Remove-NetFirewallRule -DisplayName "Polyhack - HTTP (TCP-In)" -ErrorAction SilentlyContinue
New-NetFirewallRule `
    -DisplayName "Polyhack - HTTP (TCP-In)" `
    -Direction Inbound `
    -EdgeTraversalPolicy Allow `
    -Protocol TCP `
    -LocalPort 80 `
    -Action Block `
    -Enabled True `
    >$null