#!/usr/bin/env powershell
#requires -RunAsAdministrator
#requires -Version 5.0

# This expects Acrylic DNS Proxy to have been installed already

Copy-Item `
  -Path "${PSScriptRoot}\..\.dotfiles-config\AcrylicConfiguration.ini" `
  -Destination "${Env:ProgramFiles(x86)}\Acrylic DNS Proxy\AcrylicConfiguration.ini" `
  -Force

Copy-Item `
  -Path "${PSScriptRoot}\..\.dotfiles-config\AcrylicHosts.txt" `
  -Destination "${Env:ProgramFiles(x86)}\Acrylic DNS Proxy\AcrylicHosts.txt" `
  -Force

& "${Env:ProgramFiles(x86)}\Acrylic DNS Proxy\AcrylicController.exe" PurgeAcrylicCacheDataSilently | Out-Host

# Find the best interface for going to 8.8.8.8. and set the localhost DNS for that interface

Find-NetRoute `
  -RemoteIPAddress '8.8.8.8' `
  | Select -First 1 `
  | Get-NetAdapter `
  | Set-DnsClientServerAddress -ServerAddresses '127.0.0.1','::1'
