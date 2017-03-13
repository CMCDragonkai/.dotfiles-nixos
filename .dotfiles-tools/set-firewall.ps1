#!/usr/bin/env powershell
#requires -RunAsAdministrator
#requires -Version 5.0

param (
    [string]$InstallationDirectory = "$Env:SystemDrive"
)

# We assume that there are 3 firewall profiles: Domain, Private and Public
# Domain and Private will be considered trusted networks
# We can expose networked services over these trusted networks
# Public networks will be considered untrusted networks
# We don't expose any critical network services on these untrusted networks
# Note that unidentified networks are generally placed in public networks
# Many virtual interfaces will default to un-indentified networks, and they will be placed into the public category
# It's important to remember to set them to be private
# Note that edge traversal policy is explain here: http://serverfault.com/q/89824/147813

# Accept ICMP Pings for
Set-NetFirewallRule `
    -DisplayName "File and Printer Sharing (Echo Request - ICMPv4-In)" `
    -Enabled True `
    -Action "Allow" `
    -Profile "Domain,Private" `
    >$null
Set-NetFirewallRule `
    -DisplayName "File and Printer Sharing (Echo Request - ICMPv6-In)" `
    -Enabled True `
    -Action "Allow" `
    -Profile "Domain,Private" `
    >$null

# Port 445 for Samba File Sharing
Remove-NetFirewallRule -DisplayName "File and Printer Sharing (SMB-In)" -ErrorAction SilentlyContinue
New-NetFirewallRule `
    -DisplayName "File and Printer Sharing (SMB-In)" `
    -Direction Inbound `
    -EdgeTraversalPolicy Allow `
    -Protocol TCP `
    -LocalPort 445 `
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

# Port 80 for HTTP
Remove-NetFirewallRule -DisplayName "Polyhack - HTTP (TCP-In)" -ErrorAction SilentlyContinue
New-NetFirewallRule `
    -DisplayName "Polyhack - HTTP (TCP-In)" `
    -Direction Inbound `
    -EdgeTraversalPolicy Allow `
    -Protocol TCP `
    -LocalPort 80 `
    -Action Allow `
    -Profile "Domain,Private" `
    -Enabled True `
    >$null

# Port 443 for HTTP
Remove-NetFirewallRule -DisplayName "Polyhack - HTTPS (TCP-In)" -ErrorAction SilentlyContinue
New-NetFirewallRule `
    -DisplayName "Polyhack - HTTPS (TCP-In)" `
    -Direction Inbound `
    -EdgeTraversalPolicy Allow `
    -Protocol TCP `
    -LocalPort 443 `
    -Action Allow `
    -Profile "Domain,Private" `
    -Enabled True `
    >$null

# TCP Port for Synergy Server for Domain, Private networks (by default port is 24800, however this can be changed)
# The Synergy Server is the computer with the keyboard and mouse
# The Synergy Client is the computer with the display to be controlled
# Synergy clients connect to the Synergy server, and the server is what controls the clients
# On windows the synergy GUI executable is also listening on 0.0.0.0:38400
Remove-NetFirewallRule -DisplayName "Synergy" -ErrorAction SilentlyContinue
New-NetFirewallRule `
  -DisplayName "Synergy" `
  -Direction Inbound `
  -EdgeTraversalPolicy Allow `
  -Protocol TCP `
  -LocalPort Any `
  -Profile "Domain,Private" `
  -Program "${Env:ProgramFiles}\Synergy\synergys.exe" `
  -Enabled true `
  >$null
New-NetFirewallRule `
  -DisplayName "synergy" `
  -Direction Inbound `
  -EdgeTraversalPolicy Allow `
  -Protocol TCP `
  -LocalPort Any `
  -Profile "Domain,Private" `
  -Program "${Env:ProgramFiles}\Synergy\synergy.exe" `
  -Enabled true `
  >$null

# Setup firewall to accept connections from 55555 in Domain, Private networks
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

# Setup firewall to accept connections from 55555 in Public networks
# Disabled by default
Remove-NetFirewallRule -DisplayName "Polyhack - Public Development Port (TCP-In)" -ErrorAction SilentlyContinue
Remove-NetFirewallRule -DisplayName "Polyhack - Public Development Port (UDP-In)" -ErrorAction SilentlyContinue
New-NetFirewallRule `
    -DisplayName "Polyhack - Public Development Port (TCP-In)" `
    -Direction Inbound `
    -EdgeTraversalPolicy Allow `
    -Protocol TCP `
    -LocalPort 55555 `
    -Action Allow `
    -Profile "Public" `
    -Enabled False `
    >$null
New-NetFirewallRule `
    -DisplayName "Polyhack - Public Development Port (UDP-In)" `
    -Direction Inbound `
    -EdgeTraversalPolicy Allow `
    -Protocol UDP `
    -LocalPort 55555 `
    -Action Allow `
    -Profile "Public" `
    -Enabled False `
    >$null
